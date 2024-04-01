defmodule XSocialWeb.HeaderLive do
  use Phoenix.LiveView
  alias XSocial.Auth

  def mount(_params, %{"user_id" => user_id}, socket) do
    with user when not is_nil(user) <- Auth.get_user(user_id) do
      {:ok, assign(socket, :current_user, user)}
    else
      _ ->
        {:ok, socket}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(%{current_user: current_user} = assigns) do
    ~H"""
    <header class="header-bar fixed top-0 left-0 right-0">
      <nav class="nav-bar">
        <div class="logo">XSocial</div>
        <div class="search-bar">
          <input type="text" placeholder="Search" />
        </div>
        <div class="nav-items">
          <a href="#" class="nav-item">Home</a>
          <a href="#" class="nav-item">Notifications</a>
          <a href="#" class="nav-item">Messages</a>
          <a href="#" class="nav-item">Profile</a>
        </div>
      </nav>
    </header>
    """
  end

  def render(assigns) do
    ~H"""

    """
  end
end
