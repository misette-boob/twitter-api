defmodule TwitterWeb.Api.TweetController do
  use TwitterWeb, :controller

  alias Twitter.Blog
  alias Twitter.Blog.Tweet

  action_fallback TwitterWeb.FallbackController

  def index(conn, _params) do
    tweets = Blog.list_tweets()
    render(conn, "index.json", tweets: tweets)
  end

  def show(conn, %{"id" => id}) do
    tweet = Blog.get_tweet!(id)
    render(conn, "show.json", tweet: tweet)
  end

  def create(conn, %{"tweet" => tweet_params}) do
    with {:ok, %Tweet{} = tweet} <- Blog.create_tweet(conn.assigns.current_user, tweet_params) do
      conn
      |> put_status(:created)
      |> render("show.json", tweet: tweet)
    end
  end

  def update(conn, %{"id" => id, "tweet" => tweet_params}) do
    tweet = Blog.get_tweet!(id)

    with {:ok, %Tweet{} = tweet} <- Blog.update_tweet(tweet, tweet_params) do
      render(conn, "show.json", tweet: tweet)
    end
  end

  def delete(conn, %{"id" => id}) do
    tweet = Blog.get_tweet!(id)

    with {:ok, %Tweet{}} <- Blog.delete_tweet(tweet) do
      send_resp(conn, :no_content, "")
    end
  end
end
