defmodule XSocialWeb.RoomChannel do
  use Phoenix.Channel
  # use XSocialWeb, :channel

  @impl true
  def join("room:lobby", payload, socket) do
    # if authorized?(payload) do
    #   {:ok, socket}
    # else
    #   {:error, %{reason: "unauthorized"}}
    # end

    IO.inspect("join lobby", label: "++++++++++++++++++++++++++++++++++++++++++")

    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, socket) do
    {:error, %{reason: "unauthorized"}}
    # {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end

  def handle_in("typing", params, socket) do
    IO.inspect(params, label: "typing")
    broadcast!(socket, "typing", %{body: "Someone is typing..."})
    {:noreply, socket}
  end

  def handle_in("stop_typing", params, socket) do
    IO.inspect(params, label: "stop_typing")
    broadcast!(socket, "stop_typing", %{})
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
