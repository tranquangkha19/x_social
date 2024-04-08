defmodule XSocialWeb.ProfileLive.Index do
  alias XSocial.Timeline
  use XSocialWeb, :live_view
  # Assuming you have an Auth context
  alias XSocial.Auth
  alias XSocial.Relation
  alias XSocial.Timeline

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    if connected?(socket), do: Timeline.subcribe()

    case Auth.get_user_by(%{username: username}) do
      nil ->
        {:halt, Phoenix.LiveView.redirect(socket, to: "/posts")}

      user ->
        {followers_count, following_count} = Relation.count_followers_and_followees(user.id)

        posts = Timeline.get_lastest_posts(user.id)

        owners_map = %{user.id => user}

        {:ok,
         socket
         |> assign(:user, user)
         |> assign(followers_count: followers_count)
         |> assign(following_count: following_count)
         |> assign(posts: posts)
         |> assign(owners_map: owners_map)
         |> assign(show_modal: nil)
         |> assign(modal_type: nil)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("show_verified_followers", _params, socket) do
    # Logic to handle showing verified followers
    {:noreply, socket}
  end

  @impl true
  def handle_event("show_followers", _params, socket) do
    # Logic to handle showing followers
    {:noreply, socket}
  end

  @impl true
  def handle_event("show_following", _params, socket) do
    # Logic to handle showing following
    {:noreply, socket}
  end

  @impl true
  def handle_event("show_others", _params, socket) do
    # Logic to handle showing following
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  def handle_event("follow", %{"followee-id" => followee_id}, socket) do
    Relation.add_follow(socket.assigns.current_user.id, followee_id)

    {:noreply,
     socket
     |> assign_current_user_info()
     |> update(
       :current_user_following_map,
       fn current_user_follow_map ->
         Map.put(current_user_follow_map, String.to_integer(followee_id), true)
       end
     )}
  end

  def handle_event("unfollow", %{"followee-id" => followee_id}, socket) do
    Relation.unfollow(socket.assigns.current_user.id, followee_id)

    {:noreply,
     socket
     |> assign_current_user_info()
     |> update(
       :current_user_following_map,
       fn current_user_follow_map ->
         Map.put(current_user_follow_map, String.to_integer(followee_id), false)
       end
     )}
  end

  @impl true
  def handle_event("show_modal", %{"post_id" => post_id, "modal_type" => modal_type}, socket) do
    with post_id when post_id > 0 <- String.to_integer(post_id) do
      post_show_modal = socket.assigns.posts |> Enum.find(fn p -> p.id == post_id end)
      owner_show_modal = socket.assigns.owners_map[post_show_modal.user_id]

      {:noreply,
       socket
       |> assign(show_modal: post_id)
       |> assign(modal_type: modal_type)
       |> assign(post_show_modal: post_show_modal)
       |> assign(owner_show_modal: owner_show_modal)}
    else
      _ ->
        {:noreply,
         socket
         |> assign(show_modal: nil)
         |> assign(modal_type: nil)}
    end
  end

  @impl true
  def handle_event("reply", data, socket) do
    XSocial.Timeline.reply_post(data, socket.assigns.current_user)

    {:noreply,
     socket
     |> assign(:show_modal, nil)
     |> assign(modal_type: nil)}
  end

  @impl true
  def handle_event("repost", data, socket) do
    socket =
      with {:ok, repost} <-
             XSocial.Timeline.repost_post(data, socket.assigns.current_user) do
        IO.inspect(repost, label: "123!!!!!!!!!!!")

        update(socket, :posts, fn posts ->
          [repost | posts]
        end)
      else
        _ ->
          socket
      end

    {:noreply,
     socket
     |> assign(:show_modal, nil)
     |> assign(modal_type: nil)}
  end

  def handle_info({:post_updated, post}, socket) do
    {:noreply,
     update(socket, :posts, fn posts ->
       Enum.map(posts, fn p ->
         if p.id == post.id do
           post
         else
           p
         end
       end)
     end)}
  end

  defp apply_action(socket, :following, _params) do
    following = Relation.get_all_following(socket.assigns.user.id)

    socket
    |> assign_current_user_info()
    |> assign(:following, following)
  end

  defp apply_action(socket, :followers, _params) do
    followers = Relation.get_all_followers(socket.assigns.user.id)

    socket
    |> assign_current_user_info()
    |> assign(:followers, followers)
  end

  defp apply_action(socket, :others, _params) do
    followers = Relation.get_all_others(socket.assigns.user.id)

    socket
    |> assign_current_user_info()
    |> assign(:others, followers)
  end

  defp assign_current_user_info(socket) do
    socket
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:current_user_follow_map, socket.assigns.current_user_following_map)
  end
end
