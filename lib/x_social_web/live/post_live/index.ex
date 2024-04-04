defmodule XSocialWeb.PostLive.Index do
  use XSocialWeb, :live_view

  alias XSocial.Timeline
  alias XSocial.Timeline.Post

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Timeline.subcribe()

    current_user = socket.assigns.current_user

    %{posts: posts, owners_map: owners_map} =
      Timeline.get_related_posts(socket.assigns.current_user.id)

    owners_map = Map.put(owners_map, current_user.id, current_user)

    {:ok,
     socket
     |> assign(posts: posts)
     |> assign(owners_map: owners_map)
     |> assign(show_modal: nil)
     |> assign(modal_type: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({XSocialWeb.PostLive.FormComponent, {:saved, _post}}, socket) do
    {:noreply, update(socket, :posts, fn posts -> posts end)}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
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

  @impl true
  @spec handle_event(<<_::48>>, map(), Phoenix.LiveView.Socket.t()) :: {:noreply, map()}
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
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
    XSocial.Timeline.repost_post(data, socket.assigns.current_user)

    {:noreply,
     socket
     |> assign(:show_modal, nil)
     |> assign(modal_type: nil)}
  end
end
