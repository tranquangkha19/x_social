defmodule XSocialWeb.PostLive.Show do
  use XSocialWeb, :live_view

  alias XSocial.Timeline

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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
     |> assign(:owners_map, post_details.owners_map)}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
