defmodule TwoDoWeb.Router do
  use TwoDoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TwoDoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TwoDoWeb do
    pipe_through :browser

    live "/", ListLive.Index, :index
    live "/new", ListLive.Index, :new
    live "/:id/edit", ListLive.Index, :edit

    live "/:list_id/tasks", TaskLive.Index, :index
    live "/:list_id/tasks/new", TaskLive.Index, :new
    live "/:list_id/tasks/:id/edit", TaskLive.Index, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", TwoDoWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/", TwoDoWeb do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TwoDoWeb.Telemetry
    end
  end
end
