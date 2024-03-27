defmodule XSocialWeb.AuthController do
  use XSocialWeb, :controller
  @login_path "/login"

  def auth(conn, %{"email" => email, "password" => password}) do
    case XSocial.Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: "/posts")

      _ ->
        conn
        |> redirect(to: @login_path)
    end
  end

  def logout(conn, _params) do
    endpoint_module = conn.private[:phoenix_endpoint]

    if live_socket_id = get_session(conn, :live_socket_id) do
      endpoint_module.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> put_flash(:info, "You have been logged out!")
    |> redirect(to: @login_path)
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
