defmodule XSocialWeb.ProfileLive.Index do
  use XSocialWeb, :live_view
  # Assuming you have an Auth context
  alias XSocial.Auth
  alias XSocial.Relation

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    case Auth.get_user_by(%{username: username}) do
      nil ->
        {:halt, Phoenix.LiveView.redirect(socket, to: "/posts")}

      user ->
        {followers_count, following_count} = Relation.count_followers_and_followees(user.id)

        socket =
          socket
          |> assign(:user, user)
          |> assign(followers_count: followers_count)
          |> assign(following_count: following_count)

        {:ok, socket}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end
end
