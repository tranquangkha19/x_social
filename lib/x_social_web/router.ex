defmodule XSocialWeb.Router do
  use XSocialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {XSocialWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", XSocialWeb do
    pipe_through [:browser]

    live "/login", SessionLive.Login, :show
    live "/signup", SessionLive.SignUp, :show
    get "/auth", AuthController, :auth
    get "/logout", AuthController, :logout

    live_session :ensure_authorized, on_mount: [{XSocialWeb.UserAuthLive, :ensure_authorized}] do
      get "/", PageController, :home

      live "/posts", PostLive.Index, :index
      live "/posts/new", PostLive.Index, :new
      live "/posts/:id/edit", PostLive.Index, :edit

      live "/posts/:id", PostLive.Show, :show
      live "/posts/:id/show/edit", PostLive.Show, :edit

      live "/:username", ProfileLive.Index, :index
      live "/:username/following", ProfileLive.Index, :following
      live "/:username/followers", ProfileLive.Index, :followers
      live "/:username/others", ProfileLive.Index, :others
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", XSocialWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:x_social, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: XSocialWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
