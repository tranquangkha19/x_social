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
     |> assign(:owners_map, post_details.owners_map)}
  end

  @impl true
  def handle_event("show_modal", %{"modal" => modal}, socket) do
    {:noreply,
     socket
     |> assign(:show_modal, modal)}
  end

  def handle_event("reply", data, socket) do
    with {:ok, reply} <- XSocial.Timeline.reply_post(data, socket.assigns.current_user),
         {:reply_parent_post, true} <-
           {:reply_parent_post, reply.parent_post_id == socket.assigns.post.id} do
      {:noreply,
       socket
       |> update(:replies, fn replies -> [reply | replies] end)
       |> assign(:show_modal, nil)}
    else
      _ -> {:noreply, socket}
    end
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
