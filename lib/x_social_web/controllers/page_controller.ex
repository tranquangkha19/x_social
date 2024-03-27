defmodule XSocialWeb.PageController do
  use XSocialWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, current_user: get_session(conn, :current_user))
  end
end
