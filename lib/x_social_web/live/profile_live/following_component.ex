defmodule XSocialWeb.FollowingComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <header class="profile-header">
        <div class="profile-info">
          <img class="profile-picture" src={@user.profile_picture_url} alt={@user.name} />
          <div>
            <h1 class="profile-name"><%= @user.name %></h1>
            <p class="profile-username"><%= @user.username %></p>
          </div>
        </div>
        <nav class="profile-navigation">
          <ul>
            <li class={active_class(@active_tab, :verified_followers)}>
              <a href={"/#{@user.username}/followers"} phx-click="show_verified_followers">
                Verified Followers
              </a>
            </li>
            <li class={active_class(@active_tab, :followers)}>
              <a href={"/#{@user.username}/followers"} phx-click="show_followers">Followers</a>
            </li>
            <li class={active_class(@active_tab, :following)}>
              <a href={"/#{@user.username}/following"} phx-click="show_following">Following</a>
            </li>
          </ul>
        </nav>
      </header>
      <div class="following-list">
        <%= for followee <- @following do %>
          <div class="followee" id="followee-#{followee.id}">
            <div class="followee-info">
              <img class="followee-picture" src={followee.profile_picture_url} alt={followee.name} />
              <div>
                <strong class="followee-name"><%= followee.name %></strong>
                <p class="followee-username"><%= followee.username %></p>
                <p class="followee-bio"><%= followee.username %></p>
              </div>
            </div>
            <button class="follow-button" phx-click="toggle_follow" phx-value-id={followee.id}>
              Follow
            </button>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("show_verified_followers", _params, socket) do
    # Logic to handle showing verified followers
    {:noreply, socket}
  end

  def handle_event("show_followers", _params, socket) do
    # Logic to handle showing followers
    {:noreply, socket}
  end

  def handle_event("show_following", _params, socket) do
    # Logic to handle showing following
    {:noreply, socket}
  end

  defp active_class(current_tab, tab_name) do
    if current_tab == tab_name, do: "active", else: ""
  end
end
