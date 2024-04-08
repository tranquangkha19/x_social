defmodule XSocialWeb.NotificationComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div class="user-profile-component" style="text-align: center; margin-bottom: 2rem;">
      NOTIFICATIONS
    </div>
    """
  end
end
