defmodule TwitterWeb.Router do
  use TwitterWeb, :router

  import TwitterWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TwitterWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :apiAuth do
    plug Twitter.Api.Guardian.AuthPipeline
    plug Twitter.Plugs.FetchCurrentUser
  end

  scope "/", TwitterWeb do
    pipe_through [:browser]

    get "/", PageController, :index
    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end

  ## Authentication routes

  scope "/", TwitterWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", TwitterWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
    resources "/tweets", TweetController
  end

  # Other scopes may use custom stacks.
  scope "/api", TwitterWeb.Api do
    pipe_through :api

    post "/session/new", SessionController, :new
    post "/users", UserController, :create
  end

  scope "/api", TwitterWeb.Api, as: :api do
    pipe_through [:api, :apiAuth]

    post "/session/refresh", SessionController, :refresh
    resources "/users", UserController, only: [:index, :show, :update] do
      post "/subscription", UserController, :subscribe, as: :subscription
      delete "/subscription", UserController, :unsubscribe, as: :subscription
    end

    get "/tweets/liked", TweetController, :liked, as: :liked
    get "/tweets/subscriptions", TweetController, :subscriptions, as: :subscriptions
    resources "/tweets", TweetController, except: [:new, :edit] do
      resources "/comments", CommentController, except: [:new, :edit]
      post "/like", TweetController, :like, as: :like
      delete "/like", TweetController, :dislike, as: :dislike
    end
    get "/comments", CommentController, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TwitterWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
