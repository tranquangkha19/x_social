defmodule XSocialWeb.ProfileLive.Index do
  use XSocialWeb, :live_view
  # Assuming you have an Auth context
  alias XSocial.Auth

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    case Auth.get_user_by(%{username: username}) do
      nil ->
        {:halt, Phoenix.LiveView.redirect(socket, to: "/posts")}

      user ->
        socket = assign(socket, :user, user)
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
