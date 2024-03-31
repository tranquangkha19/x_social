defmodule XSocialWeb.SidebarLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <aside class="sidebar">
      <div class="user-profile">
        <div class="profile-picture">A</div>
        <div class="profile-name">Username</div>
      </div>
      <ul class="sidebar-menu">
        <li><a href="#">Link 1</a></li>
        <li><a href="#">Link 2</a></li>
        <li><a href="#">Link 3</a></li>
        <li><a href="#">Link 4</a></li>
      </ul>
    </aside>
    """
  end
end
