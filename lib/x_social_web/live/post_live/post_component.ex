defmodule XSocialWeb.PostLive.PostComponent do
  use XSocialWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <article class="post border-gray-300 shadow-sm">
      <!-- Post Header with avatar and username -->
      <header class="post-header p-4 flex items-center">
        <a href={"/#{@owner.username}"}>
          <img
            class="profile-picture"
            src={@owner.profile_picture_url}
            alt={@owner.username}
            class="rounded-full"
          />
        </a>
        <div class="ml-2">
          <p>
            <a href={"/#{@owner.username}"}>
              <span class="font-bold">@<%= @owner.username %></span>
            </a>

            <%= if @is_main == true && @post.parent_post_id && @parent_post  do %>
              <a href={"/posts/#{@post.parent_post_id}"}>
                <span class="text-gray-500">
                  replying to @<%= @parent_post.username %>
                </span>
              </a>
            <% end %>
          </p>
          <a href={"/posts/#{@post.id}"}>
            <p class="text-gray-500 text-sm">
              <%= DateTime.to_string(@post.inserted_at) |> String.slice(0..18) %>
            </p>
          </a>
        </div>
      </header>
      <!-- Post Content -->
      <a href={"/posts/#{@post.id}"}>
        <div class="post-content px-4">
          <p><%= @post.body %></p>
          <%= if @post.image_url do %>
            <img src={@post.image_url} alt="Post image" class="mt-2 rounded" />
          <% end %>
        </div>
      </a>
      <!-- Post Actions -->
      <div class="actions-bar p-4 flex justify-between items-center text-gray-500">
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
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
            </path>
          </svg>
          <span><%= @post.likes_count %></span>
        </button>
        <!-- Comment action -->
        <button
          class="flex items-center space-x-1"
          phx-click="show_modal"
          phx-value-modal={"comment-#{@post.id}"}
          type="button"
        >
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
            <path d="M17 2.1l4 4-4 4" /><path d="M3 12.2v-2a4 4 0 0 1 4-4h12.8M7 21.9l-4-4 4-4" /><path d="M21 11.8v2a4 4 0 0 1-4 4H4.2" />
          </svg>
          <span><%= @post.reposts_count %></span>
        </button>
        <!-- Main modal -->
      </div>
      <%= if @show_modal == "comment-#{@post.id}" do %>
        <div
          id={"crud-modal-#{@post.id}"}
          tabindex="-1"
          aria-hidden="true"
          class="overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
        >
          <div
            class="fixed top-0 left-0 w-full h-full opacity-10 bg-slate-950"
            type="button"
            phx-click="show_modal"
            phx-value-modal=""
          >
          </div>
          <div class="flex justify-center items-center h-full">
            <div class="relative p-4 w-full max-w-md max-h-full top-56px">
              <!-- Modal content -->
              <div class="relative bg-white rounded-lg shadow">
                <!-- Modal header -->

              <!-- Modal body -->
                <header class="post-header p-4 flex items-center">
                  <a href={"/#{@owner.username}"}>
                    <img
                      class="profile-picture"
                      src={@owner.profile_picture_url}
                      alt={@owner.username}
                      class="rounded-full"
                    />
                  </a>
                  <div class="ml-2">
                    <p>
                      <a href={"/#{@owner.username}"}>
                        <span class="font-bold">@<%= @owner.username %></span>
                      </a>

                      <%= if @is_main == true && @post.parent_post_id && @parent_post  do %>
                        <a href={"/posts/#{@post.parent_post_id}"}>
                          <span class="text-gray-500">
                            replying to @<%= @parent_post.username %>
                          </span>
                        </a>
                      <% end %>
                    </p>
                    <a href={"/posts/#{@post.id}"}>
                      <p class="text-gray-500 text-sm">
                        <%= DateTime.to_string(@post.inserted_at) |> String.slice(0..18) %>
                      </p>
                    </a>
                  </div>
                </header>
                <!-- Post Content -->
                <a href={"/posts/#{@post.id}"}>
                  <div class="post-content px-4">
                    <p><%= @post.body %></p>
                    <%= if @post.image_url do %>
                      <img src={@post.image_url} alt="Post image" class="mt-2 rounded" />
                    <% end %>
                  </div>
                </a>
                <form class="p-4 md:p-4" phx-submit="reply">
                  <div class="grid gap-4 grid-cols-2">
                    <div class="col-span-2">
                      <textarea
                        id="reply"
                        rows="1"
                        type="reply"
                        name="reply"
                        class="block p-2.5 w-full text-sm text-gray-900  rounded-lg border  focus:ring-blue-500 focus:border-blue-500"
                        placeholder="Reply here"
                      ></textarea>
                    </div>
                    <div class="col-span-2">
                      <input type="hidden" name="post_id" value={@post.id} />
                    </div>

                    <div class="col-span-2 sm:col-span-1"></div>
                    <div class="col-span-2 sm:col-span-1 inline-flex justify-end items-center">
                      <button
                        type="submit"
                        class="text-white inline-flex items-center bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
                      >
                        Post
                      </button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </article>
    """
  end

  @impl true
  def handle_event("like", _, socket) do
    XSocial.Timeline.inc_likes(socket.assigns.post)
    {:noreply, socket}
  end

  @impl true
  def handle_event("repost", _, socket) do
    XSocial.Timeline.inc_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end
