defmodule XSocialWeb.NotificationLive.Index do
  alias XSocial.Relation
  alias XSocial.Timeline
  use XSocialWeb, :live_view

  @impl true
  def mount(_, session, socket) do
    if connected?(socket), do: Timeline.subcribe()
    notifications = Relation.get_notifications(session["user_id"])
    {:ok, assign(socket, :notifications, notifications)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end
end
