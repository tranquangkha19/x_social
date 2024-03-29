defmodule XSocialWeb.FollowButtonComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    assigns =
      assign(
        assigns,
        :is_following,
        Map.get(assigns.current_user_following_map, assigns.followee_id) == true
      )

    ~H"""
    <button
      class={
      "follow-button #{@is_following && "following" || "not-following"}"
      }
      phx-click={if @is_following, do: "unfollow", else: "follow"}
      phx-value-id={@followee_id}
      phx-value-followee-id={@followee_id}
    >
      <%= if @is_following do %>
        Following
      <% else %>
        Follow
      <% end %>
    </button>
    """
  end
end
