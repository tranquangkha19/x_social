defmodule XSocialWeb.PostLive.Show do
  use XSocialWeb, :live_view

  alias XSocial.Timeline

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:show_modal, nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    post_details = Timeline.get_details_post(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, post_details.post)
     |> assign(:user, post_details.user)
     |> assign(:parent_post, post_details.parent_post)
     |> assign(:replies, post_details.replies)
     |> assign(:show_modal, nil)
     |> assign(:modal_type, nil)
     |> assign(:owners_map, post_details.owners_map)}
  end

  @impl true
  def handle_event("show_modal", %{"post_id" => post_id, "modal_type" => modal_type}, socket) do
    with post_id when post_id > 0 <- String.to_integer(post_id) do
      post_show_modal =
        if socket.assigns.post.id == post_id do
          socket.assigns.post
        else
          socket.assigns.replies |> Enum.find(fn r -> r.id == post_id end)
        end

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

  def handle_event("reply", data, socket) do
    with {:ok, reply} <- XSocial.Timeline.reply_post(data, socket.assigns.current_user),
         {:reply_parent_post, true} <-
           {:reply_parent_post, reply.parent_post_id == socket.assigns.post.id} do
      {:noreply,
       socket
       |> update(:replies, fn replies -> [reply | replies] end)
       |> assign(:show_modal, nil)
       |> assign(modal_type: nil)}
    else
      _ ->
        {:noreply,
         socket
         |> assign(:show_modal, nil)
         |> assign(modal_type: nil)}
    end
  end

  def handle_event("repost", data, socket) do
    with {:ok, _repost} <- XSocial.Timeline.repost_post(data, socket.assigns.current_user) do
      {:noreply,
       socket
       |> assign(:show_modal, nil)
       |> assign(modal_type: nil)}
    else
      _ ->
        {:noreply,
         socket
         |> assign(:show_modal, nil)
         |> assign(modal_type: nil)}
    end
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
