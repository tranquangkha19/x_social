defmodule XSocialWeb.PostLive.PostComponent do
  use XSocialWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <article class="post border-gray-300 shadow-md">
      <!-- Post Header with avatar and username -->
      <header class="post-header p-4 flex items-center">
        <img src="https://via.placeholder.com/50" alt={@post.username} class="rounded-full" />
        <div class="ml-2">
          <p class="font-bold">@<%= @post.username %></p>
          <p class="text-gray-500"><%= @post.inserted_at %></p>
        </div>
      </header>
      <!-- Post Content -->
      <div class="post-content p-4">
        <p><%= @post.body %></p>
        <img
          src="https://pbs.twimg.com/card_img/1772068419896217600/ilRk2gPX?format=jpg&name=small"
          alt="Post image"
          class="mt-2 rounded"
        />
      </div>
      <!-- Post Actions -->
      <div class="actions-bar p-4 flex justify-between items-center text-gray-500">
        <!-- Comment action -->
        <button phx-click="comment" phx-target={@myself} class="flex items-center space-x-1">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="18"
            height="18"
            viewBox="0 0 24 24"
            fill="none"
            stroke="#A1A1AA"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z">
            </path>
          </svg>
          <span><%= "200" %></span>
        </button>
        <!-- Repost action -->
        <button phx-click="repost" phx-target={@myself} class="flex items-center space-x-1">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="18"
            height="18"
            viewBox="0 0 24 24"
            fill="none"
            stroke="#A1A1AA"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
            </path>
          </svg>
          <span><%= @post.reposts_count %></span>
        </button>
        <!-- Like action -->
        <button phx-click="like" phx-target={@myself} class="flex items-center space-x-1">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="18"
            height="18"
            viewBox="0 0 24 24"
            fill="none"
            stroke="#A1A1AA"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M17 2.1l4 4-4 4" /><path d="M3 12.2v-2a4 4 0 0 1 4-4h12.8M7 21.9l-4-4 4-4" /><path d="M21 11.8v2a4 4 0 0 1-4 4H4.2" />
          </svg>
          <span><%= @post.likes_count %></span>
        </button>
      </div>
    </article>
    """
  end

  @impl true
  def handle_event("like", _, socket) do
    IO.inspect("vo like roi ne !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    XSocial.Timeline.inc_likes(socket.assigns.post)
    {:noreply, socket}
  end

  @impl true
  def handle_event("repost", _, socket) do
    XSocial.Timeline.inc_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end
