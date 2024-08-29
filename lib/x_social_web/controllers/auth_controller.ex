defmodule XSocialWeb.AuthController do
  use XSocialWeb, :controller
  @login_path "/login"

  def auth(conn, %{"username" => username, "password" => password}) do
    IO.inspect(username, label: "username!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

    case XSocial.Auth.authenticate_user(username, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: "/posts")

      _ ->
        conn
        |> put_flash(:error, "Login failed. Please check your username and password!")
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
