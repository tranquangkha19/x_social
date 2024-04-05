defmodule XSocialWeb.UserProfileComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div class="user-profile-component" style="text-align: center; margin-bottom: 2rem;">
      <div class="cover-image-container" style="position: relative; margin-bottom: 4rem;">
        <img src={@cover_picture} alt="Cover" style="width: 100%; height: auto; object-fit: cover;" />
        <img
          src={@profile_picture}
          alt="Profile picture"
          style="width: 150px; height: 150px; border-radius: 50%; border: 3px solid white; position: absolute; bottom: -75px; left: 50%; transform: translateX(-50%); object-fit: cover;"
        />
      </div>
      <div style="padding: 2rem;">
        <h2 style="margin: 0; padding: 0;"><%= @name %></h2>
        <p style="color: #555;">@<%= @username %></p>
        <p style="color: #777; margin-top: 1rem;"><%= @bio %></p>
      </div>
      <div style="background: #f9f9f9; padding: 1rem; border-top: 1px solid #eee;">
        <div style="display: inline-block;" class="mx-2">
          <a
            href={"/#{@username}/followers"}
            rel="noopener"
            style="color: #0066cc; text-decoration: none;"
          >
            <strong><%= @followers_count %></strong>
            <span style="color: #555;">Followers</span>
          </a>
        </div>
        <div style="display: inline-block;" class="mx-2">
          <a
            href={"/#{@username}/following"}
            rel="noopener"
            style="color: #0066cc; text-decoration: none;"
          >
            <strong><%= @following_count %></strong>
            <span style="color: #555;">Following</span>
          </a>
        </div>
        <div style="display: inline-block;" class="mx-2">
          <a
            href={"/#{@username}/others"}
            rel="noopener"
            style="color: #0066cc; text-decoration: none;"
          >
            <span style="color: #555;">Others</span>
          </a>
        </div>
      </div>
    </div>
    """
  end
end
