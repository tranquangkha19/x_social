defmodule XSocialWeb.FollowingComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <header class="profile-header shadow-sm">
        <div class="profile-info">
          <img class="profile-picture" src={@user.profile_picture_url} alt={@user.name} />
          <div>
            <h1 class="profile-name"><%= @user.name %></h1>
            <p class="profile-username"><%= @user.username %></p>
          </div>
        </div>
        <nav class="profile-navigation">
          <ul>
            <li class={active_class(@active_tab, :others)}>
              <a href={"/#{@user.username}/others"} phx-click="show_others">Others</a>
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
          <div class="followee shadow-sm" id="followee-#{followee.id}">
            <div class="followee-info">
              <img class="followee-picture" src={followee.profile_picture_url} alt={followee.name} />
              <div>
                <p class="followee-name"><%= followee.name %></p>
                <p class="followee-username"><%= followee.username %></p>
              </div>
            </div>
            <.live_component
              module={XSocialWeb.FollowButtonComponent}
              id={followee.id}
              followee_id={followee.id}
              current_user_following_map={@current_user_following_map}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp active_class(current_tab, tab_name) do
    if current_tab == tab_name, do: "active", else: ""
  end
end
