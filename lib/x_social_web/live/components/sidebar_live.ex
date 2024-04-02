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
      <div class="followee-info user-profile">
        <a href={"/#{@current_user.username}"}>
          <img
            class="followee-picture"
            src={@current_user.profile_picture_url}
            alt={@current_user.name}
          />
          <div>
            <strong class="followee-name"><%= @current_user.name %></strong>
            <p class="followee-username">@<%= @current_user.username %></p>
          </div>
        </a>
      </div>
      <ul class="sidebar-menu">
        <li><a href="/posts">Home</a></li>
        <li><a href="/notifications">Notifications</a></li>
        <li><a href="/messages">Messages</a></li>
        <li><a href={"/#{@current_user.username}"}>Profile</a></li>
        <li><a href="/posts/new">Post</a></li>
      </ul>
    </aside>
    """
  end

  def render(assigns) do
    ~H"""

    """
  end
end
