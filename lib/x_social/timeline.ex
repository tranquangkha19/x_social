defmodule XSocial.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias XSocial.Repo

  alias XSocial.Timeline.Post
  alias XSocial.Timeline.PostType
  alias XSocial.Relation.Follow
  alias XSocial.Auth.User
  alias XSocial.Timeline.Like

  def get_related_posts(user_id, page_number \\ 1, page_size \\ 10) do
    posts =
      Repo.all(
        from p in Post,
          where: p.type == ^PostType.post(),
          join: f in Follow,
          on:
            f.followee_id == p.user_id and f.user_id == ^user_id and f.active == true and
              p.type in [^PostType.post(), ^PostType.repost()],
          order_by: [desc: p.inserted_at],
          limit: ^page_size,
          offset: (^page_number - 1) * ^page_size,
          select: p
      )
      |> Repo.preload([:user, original_post: [:user]])

    user_posts = get_lastest_posts(user_id)

    posts = (posts ++ user_posts) |> Enum.sort_by(& &1.id, :desc)

    owners_map = get_users_by_posts(posts)

    %{posts: posts, owners_map: owners_map}
  end

  def get_lastest_posts(user_id, page_number \\ 1, page_size \\ 10) do
    Repo.all(
      from post in Post,
        where: post.user_id == ^user_id and post.type in [^PostType.post(), ^PostType.repost()],
        order_by: [desc: post.inserted_at],
        limit: ^page_size,
        offset: (^page_number - 1) * ^page_size,
        select: post
    )
    |> Repo.preload([:user, original_post: [:user]])
  end

  # XSocial.Timeline.get_related_posts(1)
  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(from p in Post, order_by: [desc: p.inserted_at])
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_details_post(post_id) do
    post =
      Repo.get!(Post, post_id)
      |> Repo.preload([:user, original_post: [:user]])

    parent_post =
      if post.parent_post_id do
        Repo.get!(Post, post.parent_post_id)
      else
        nil
      end
      |> Repo.preload([:user, original_post: [:user]])

    replies =
      Repo.all(
        from p in Post, where: p.parent_post_id == ^post_id, order_by: [asc: p.inserted_at]
      ) ||
        []
        |> Repo.preload([:user, original_post: [:user]])

    posts =
      if parent_post do
        [parent_post | [post | replies]]
      else
        [post | replies]
      end

    owners_map = get_users_by_posts(posts)

    %{
      post: post,
      user: owners_map[post.user_id],
      parent_post: parent_post,
      replies: replies,
      owners_map: owners_map
    }
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:post_created)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
    |> broadcast(:post_updated)
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def like_post(%Post{id: post_id} = post, %User{id: user_id} = user) do
    like =
      Repo.one(from like in Like, where: like.user_id == ^user_id and like.post_id == ^post_id)

    case like do
      # like post
      nil ->
        %Like{}
        |> Like.changeset(%{
          user_id: user_id,
          post_id: post_id,
          user_name: user.username,
          active: true
        })
        |> Repo.insert()

        inc_likes(post)

      # like post
      %Like{active: false} = inactive_follow ->
        Repo.update(Like.changeset(inactive_follow, %{active: true}))
        inc_likes(post)

      # unlike post
      active_like ->
        Repo.update(Like.changeset(active_like, %{active: false}))
        dec_likes(post)
    end
  end

  def inc_likes(%Post{id: id}) do
    {1, [post]} =
      from(post in Post, where: post.id == ^id, select: post)
      |> Repo.update_all(inc: [likes_count: 1])

    broadcast({:ok, post |> Repo.preload([:user, original_post: [:user]])}, :post_updated)
  end

  def dec_likes(%Post{id: id}) do
    {1, [post]} =
      from(post in Post, where: post.id == ^id, select: post)
      |> Repo.update_all(inc: [likes_count: -1])

    broadcast({:ok, post |> Repo.preload([:user, original_post: [:user]])}, :post_updated)
  end

  def inc_reposts(post_id) do
    {1, [post]} =
      from(post in Post, where: post.id == ^post_id, select: post)
      |> Repo.update_all(inc: [reposts_count: 1])

    broadcast({:ok, post |> Repo.preload([:user, original_post: [:user]])}, :post_updated)
  end

  def inc_replies(post_id) do
    {1, [post]} =
      from(post in Post, where: post.id == ^post_id, select: post)
      |> Repo.update_all(inc: [replies_count: 1])

    broadcast({:ok, post |> Repo.preload([:user, original_post: [:user]])}, :post_updated)
  end

  def reply_post(reply, user) do
    post_id = reply["post_id"]

    attrs = %{
      "body" => reply["reply"],
      "username" => user.username,
      "user_id" => user.id,
      "parent_post_id" => reply["post_id"],
      "type" => XSocial.Timeline.PostType.reply()
    }

    with {:ok, %{reply: reply}} <-
           Ecto.Multi.new()
           |> Ecto.Multi.insert(
             :reply,
             Post.changeset(%Post{}, attrs)
           )
           |> Ecto.Multi.run(
             :inc_replies,
             fn _repo, _changes ->
               inc_replies(post_id)
             end
           )
           |> Repo.transaction() do
      {:ok, reply}
    end
  end

  def repost_post(reply, user) do
    post_id = reply["post_id"]

    attrs = %{
      "body" => reply["reply"],
      "username" => user.username,
      "user_id" => user.id,
      "original_post_id" => reply["post_id"],
      "type" => XSocial.Timeline.PostType.repost()
    }

    with {:ok, %{repost: repost}} <-
           Ecto.Multi.new()
           |> Ecto.Multi.insert(
             :repost,
             Post.changeset(%Post{}, attrs)
           )
           |> Ecto.Multi.run(
             :inc_reposts,
             fn _repo, _changes ->
               inc_reposts(post_id)
             end
           )
           |> Repo.transaction() do
      {:ok, repost |> Repo.preload([:user, original_post: [:user]])}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def subcribe do
    Phoenix.PubSub.subscribe(XSocial.PubSub, "posts")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(XSocial.PubSub, "posts", {event, post})
    {:ok, post}
  end

  defp get_users_by_posts(posts) do
    owner_ids = Enum.map(posts, fn post -> post.user_id end)

    Repo.all(
      from owner in User,
        where: owner.id in ^owner_ids,
        select: owner
    )
    |> Enum.into(%{}, fn owner -> {owner.id, owner} end)
  end
end
