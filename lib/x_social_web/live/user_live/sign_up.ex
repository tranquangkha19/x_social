defmodule XSocialWeb.UserLive.SignUp do
  use XSocialWeb, :live_view

  def render(assigns) do
    ~H"""
    <form phx-submit="register">
      <div>
        <input name="email" type="email" placeholder="Email" value={@changeset.data.email} />
        <%= for {msg, _} <- Keyword.get(@changeset.errors, :email, []),
                do: "<div class=\"error-message\">#{msg}</div>" %>
      </div>
      <div>
        <input name="password" type="password" placeholder="Password" />
        <%= for {msg, _} <- Keyword.get(@changeset.errors, :password, []),
                do: "<div class=\"error-message\">#{msg}</div>" %>
      </div>
      <button type="submit">Register</button>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    changeset = XSocial.Auth.change_user(%XSocial.Auth.User{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("register", %{"email" => email, "password" => password}, socket) do
    IO.inspect("hahahahah")

    case XSocial.Auth.create_user(%{email: email, username: email, password: password}) do
      {:ok, _user} ->
        IO.inspect("successsssss")

        {:noreply,
         socket |> put_flash(:info, "Registered successfully!") |> redirect(to: "/login")}

      {:error, changeset} ->
        IO.inspect("failllllllllllll")
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
