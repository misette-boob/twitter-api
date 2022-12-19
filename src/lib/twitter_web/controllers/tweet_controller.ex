defmodule TwitterWeb.TweetController do
  use TwitterWeb, :controller

  alias Twitter.Blog
  alias Twitter.Blog.Tweet

  def index(conn, params) do
    tweets = Blog.list_tweets(params)
    render(conn, "index.html", tweets: tweets, current_user_id: conn.assigns.current_user.id)
  end

  def new(conn, _params) do
    changeset = Blog.change_tweet(%Tweet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tweet" => tweet_params}) do
    case Blog.create_tweet(conn.assigns.current_user, tweet_params) do
      {:ok, tweet} ->
        conn
        |> put_flash(:info, "Tweet created successfully.")
        |> redirect(to: Routes.tweet_path(conn, :show, tweet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tweet = Blog.get_tweet!(id)
    render(conn, "show.html", tweet: tweet)
  end

  def edit(conn, %{"id" => id}) do
    tweet = Blog.get_tweet!(id)
    changeset = Blog.change_tweet(tweet)
    render(conn, "edit.html", tweet: tweet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tweet" => tweet_params}) do
    tweet = Blog.get_tweet!(id)

    case Blog.update_tweet(tweet, tweet_params) do
      {:ok, tweet} ->
        conn
        |> put_flash(:info, "Tweet updated successfully.")
        |> redirect(to: Routes.tweet_path(conn, :show, tweet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tweet: tweet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tweet = Blog.get_tweet!(id)
    {:ok, _tweet} = Blog.delete_tweet(tweet)

    conn
    |> put_flash(:info, "Tweet deleted successfully.")
    |> redirect(to: Routes.tweet_path(conn, :index))
  end
end
