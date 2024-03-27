defmodule XSocialWeb.UserAuthLive do
  import Phoenix.LiveView
  import Phoenix.Component
  alias XSocial.Auth

  def on_mount(:ensure_authorized, _params, %{"user_id" => user_id} = _session, socket) do
    user = Auth.get_user(user_id)
    socket = assign(socket, :current_user, user)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end

  def on_mount(:ensure_authorized, _params, _session, socket) do
    {:halt, redirect(socket, to: "/login")}
  end
end
