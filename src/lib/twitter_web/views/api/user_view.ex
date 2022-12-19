defmodule TwitterWeb.Api.UserView do
  use TwitterWeb, :view
  alias TwitterWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user_list.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      date_birth: user.date_birth,
      subscriptions: user.subscriptions,
      subscribers: user.subscribers
    }
  end

  def render("user_list.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      date_birth: user.date_birth
    }
  end
end
