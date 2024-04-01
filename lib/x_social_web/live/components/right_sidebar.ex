defmodule XSocialWeb.RightSidebar do
  use Phoenix.LiveView

  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok, assign(socket, :user_id, user_id)}
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(%{user_id: user_id} = assigns) do
    ~H"""
    <aside class="sidebar"></aside>
    """
  end

  def render(assigns) do
    ~H"""

    """
  end
end
