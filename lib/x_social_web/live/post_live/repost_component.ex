defmodule XSocialWeb.PostLive.RepostComponent do
  use XSocialWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <article class="m-4  border-solid rounded-lg  border-gray-400 shadow">
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
      <a href={"/posts/#{@post.id}"}>
        <div class="post-content px-4 pb-4">
          <p><%= @post.body %></p>
          <%= if @post.image_url do %>
            <img src={@post.image_url} alt="Post image" class="mt-2 rounded" />
          <% end %>
        </div>
      </a>
      <!-- Actions -->
      <div class="actions-bar p-4 flex justify-between items-center text-gray-500">
        <!-- Like action -->
        <div class="flex items-center space-x-1">
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
        </div>
        <!-- Comment action -->
        <div class="flex items-center space-x-1">
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
        </div>
        <!-- Repost action -->
        <div class="flex items-center space-x-1">
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
        </div>
      </div>
    </article>
    """
  end
end
