defmodule XSocialWeb.MessageComponent do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div class="" style="text-align: left; margin-bottom: 2rem;">
      <%= for noti <- @notifications do %>
        <div class="flex p-4 mb-4 text-sm rounded-lg shadow">
          <div class="flex-1" role="alert">
            <span class="font-lg font-bold">
              <a href={"/#{noti.actioner.username}"}>
                @<%= noti.actioner.username %>
              </a>
            </span>
            <%= noti.type %>s <a class="underline" href={"/posts/#{noti.post_id}"}>your post</a>
          </div>
          <div class="flex-1 text-right">
            <%= noti.inserted_at %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
