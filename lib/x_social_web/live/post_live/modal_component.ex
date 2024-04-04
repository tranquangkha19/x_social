defmodule XSocialWeb.PostLive.ModalComponent do
  use XSocialWeb, :live_component

  @impl true
  def render(assigns) do
    # component params: post, owner, is_main, parent_post
    # post_show_modal, owner_show_modal

    ~H"""
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
        phx-value-post_id={-1}
        phx-value-modal_type=""
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
                  <img src={@post.image_url} alt="Post image" class="mt-2 rounded-lg" />
                <% end %>
              </div>
            </a>
            <form class="p-4 md:p-4" phx-submit={@modal_type}>
              <div class="grid gap-4 grid-cols-2">
                <div class="col-span-2">
                  <textarea
                    id="reply"
                    rows="1"
                    type="reply"
                    name="reply"
                    class="block p-2.5 w-full text-sm text-gray-900  rounded-lg border focus:ring-blue-500 focus:border-blue-500"
                    placeholder=""
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
                    <%= if @modal_type == "reply" do %>
                      Reply
                    <% else %>
                      Repost
                    <% end %>
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
