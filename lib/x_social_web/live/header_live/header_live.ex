defmodule XSocialWeb.HeaderLive do
  use Phoenix.LiveView
  alias XSocial.Auth

  def mount(_params, %{"user_id" => user_id}, socket) do
    with user when not is_nil(user) <- Auth.get_user(user_id) do
      {:ok, assign(socket, :current_user, user)}
    else
      _ ->
        {:ok, socket}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(%{current_user: current_user} = assigns) do
    ~H"""
    <header class="header-bar fixed top-0 left-0 right-0">
      <nav class="nav-bar">
        <div class="logo">XSocial</div>
        <div class="search-bar">
          <input type="text" placeholder="Search" />
        </div>
        <div class="nav-items">
          <a href="/logout" class="nav-item !ml-0">
            <svg
              class="h-7 w-7 text-black-500"
              width="18"
              height="18"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" />
              <path d="M14 8v-2a2 2 0 0 0 -2 -2h-7a2 2 0 0 0 -2 2v12a2 2 0 0 0 2 2h7a2 2 0 0 0 2 -2v-2" />
              <path d="M7 12h14l-3 -3m0 6l3 -3" />
            </svg>
          </a>
        </div>
      </nav>
    </header>
    """
  end

  def render(assigns) do
    ~H"""

    """
  end
end
