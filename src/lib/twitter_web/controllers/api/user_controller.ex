defmodule TwitterWeb.Api.UserController do
  use TwitterWeb, :controller

  alias Twitter.Api.Accounts
  alias Twitter.Accounts.User
  alias Twitter.Blog
  alias Twitter.Blog.Subscription

  action_fallback TwitterWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def subscribe(conn, %{"user_id" => user_id}) do
    with {:ok, %Subscription{}} <- Blog.subscribe(conn, user_id) do
      send_resp(conn, 201, "")
    end
  end

  def unsubscribe(conn, %{"user_id" => user_id}) do
    with {_, nil} <- Blog.unsubscribe(conn, user_id) do
      send_resp(conn, 200, "")
    end
  end
end
