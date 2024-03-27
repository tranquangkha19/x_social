defmodule XSocialWeb.SessionLive.Login do
  use XSocialWeb, :live_view

  def render(assigns) do
    ~H"""
    <form phx-submit="authenticate">
      <input name="email" type="text" placeholder="Email" value={@email} />
      <input name="password" type="password" placeholder="Password" />
      <button type="submit">Login</button>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, email: "")}
  end

  def handle_event("authenticate", %{"email" => email, "password" => password}, socket) do
    {:noreply, redirect(socket, to: "/auth?email=#{email}&password=#{password}")}
  end
end
