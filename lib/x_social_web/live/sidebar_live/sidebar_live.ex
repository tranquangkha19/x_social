defmodule XSocialWeb.SidebarLive do
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
    <aside class="sidebar">
      <div class="user-profile">
        <div class="profile-picture">A</div>
        <div class="profile-name"><%= @current_user.name %></div>
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

  def render(assigns) do
    ~H"""

    """
  end
end
