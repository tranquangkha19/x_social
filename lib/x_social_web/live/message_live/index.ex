defmodule XSocialWeb.MessageLive.Index do
  alias XSocial.Relation
  alias XSocial.Timeline
  alias XSocialWeb.Presence
  alias Phoenix.Socket.Broadcast
  use XSocialWeb, :live_view

  @presence_key "live_in_room"

  @impl true
  def mount(_, session, socket) do
    room = nil

    if connected?(socket) do
      Timeline.subcribe()
      Phoenix.PubSub.subscribe(XSocial.PubSub, topic(room))
      Phoenix.PubSub.subscribe(XSocial.PubSub, "room:lobby")

      {:ok, _ref} =
        Presence.track(self(), topic(room), @presence_key, %{user_id: session["user_id"]})
    end

    live_in_room = get_live_in_room_count(room)
    notifications = Relation.get_notifications(session["user_id"])

    {:ok,
     socket
     |> assign(:notifications, notifications)
     |> assign(:room, room)
     |> assign(:live_in_room, live_in_room)
     |> assign(:typing, false)
     |> assign(:messages, [])}
  end

  @impl Phoenix.LiveView
  def handle_info(%Broadcast{event: "presence_diff"} = _event, socket) do
    live_in_room = get_live_in_room_count(socket.assigns.room)

    {:noreply, assign(socket, :live_in_room, live_in_room)}
  end

  defp get_live_in_room_count(room) do
    IO.inspect(Presence.list(topic(room)),
      label: "Presence.list(topic(room)) *************************************"
    )

    case Presence.list(topic(room)) do
      %{@presence_key => %{metas: list}} -> Enum.count(list)
      _other -> 0
    end
  end

  def handle_info(%Broadcast{topic: "room:lobby", event: "typing"} = event, socket) do
    {:noreply, socket |> assign(:typing, true)}
  end

  def handle_info(%Broadcast{topic: "room:lobby", event: "stop_typing"} = event, socket) do
    IO.inspect(event,
      label: "Received typing event ++++++++++++++++++++++++++++++++++++++++++++@@@!!!"
    )

    {:noreply, socket |> assign(:typing, false)}
  end

  def handle_info(%Broadcast{topic: "room:lobby", event: "new_msg"} = event, socket) do
    IO.inspect(event,
      label: "Received event ++++++++++++++++++++++++++++++++++++++++++++@@@!!!@@@@@@@@@@@@@@@@@"
    )

    {:noreply, socket |> assign(:messages, socket.assigns.messages ++ [event.payload])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    {:noreply, socket}
  end

  defp apply_action(socket, _, _params) do
    socket
  end

  defp topic(nil) do
    "room:public"
  end

  defp topic(%{id: id} = _room) do
    "room:#{id}"
  end
end
