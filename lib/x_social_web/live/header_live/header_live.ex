defmodule XSocialWeb.HeaderLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <header class="header-bar fixed top-0 left-0 right-0">
      <nav class="nav-bar">
        <div class="logo">K</div>
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
end
