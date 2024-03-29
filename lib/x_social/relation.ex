defmodule XSocial.Relation do
  @moduledoc """
  The Relation context.
  """

  import Ecto.Query, warn: false
  alias XSocial.Repo

  alias XSocial.Relation.Follow
  alias XSocial.Auth.User

  # get all followees of a user
  # the use follow them (followees)

  def count_followers_and_followees(user_id) do
    {count_followers(user_id), count_followees(user_id)}
  end

  def count_followers(user_id) do
    # Query to count the number of followers

    Repo.aggregate(
      from(f in Follow,
        where: f.followee_id == ^user_id and f.active == true
      ),
      :count,
      :id
    )
  end

  def count_followees(user_id) do
    # Query to count the number of followees

    Repo.aggregate(
      from(f in Follow,
        where: f.user_id == ^user_id and f.active == true
      ),
      :count,
      :id
    )
  end

  def get_all_followers(user_id) do
    Repo.all(
      from follow in Follow,
        join: follower in User,
        on: follower.id == follow.user_id,
        where: follow.followee_id == ^user_id and follow.active == true,
        order_by: [desc: follow.inserted_at],
        select: follower
    )
  end

  def get_all_following(user_id) do
    Repo.all(
      from follow in Follow,
        join: followee in User,
        on: followee.id == follow.followee_id,
        where: follow.user_id == ^user_id and follow.active == true,
        order_by: [desc: follow.inserted_at],
        select: followee
    )
  end

  def get_all_following_ids(user_id) do
    Repo.all(
      from follow in Follow,
        where: follow.user_id == ^user_id and follow.active == true,
        select: follow.followee_id
    )
  end

  def add_follow(user_id, followee_id) do
    follow_relation =
      Repo.one(
        from follow in Follow,
          where: follow.user_id == ^user_id and follow.followee_id == ^followee_id
      )

    case follow_relation do
      nil ->
        %Follow{}
        |> Follow.changeset(%{
          user_id: user_id,
          followee_id: followee_id,
          active: true,
          followed_at: DateTime.utc_now()
        })
        |> Repo.insert()

      %Follow{active: false} = inactive_follow ->
        Repo.update(Follow.changeset(inactive_follow, %{active: true}), prefix: "relation")

      _active_follow ->
        {:ok, follow_relation}
    end
  end

  def unfollow(user_id, followee_id) do
    Repo.update_all(
      from(follow in Follow,
        where: follow.user_id == ^user_id and follow.followee_id == ^followee_id
      ),
      set: [active: false]
    )
  end
end
