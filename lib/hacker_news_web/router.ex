defmodule HNWeb.Router do
  use HNWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HNWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HNWeb do
    pipe_through :browser

    live "/", HomeLive, :news
    live "/new", HomeLive, :newest
    live "/show", HomeLive, :show
    live "/ask", HomeLive, :ask
    live "/jobs", HomeLive, :jobs
    live "/items/:id", ItemLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", HNWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:hacker_news, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HNWeb.Telemetry
    end
  end
end
