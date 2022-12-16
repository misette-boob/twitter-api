defmodule TwitterWeb.Api.TweetView do
  use TwitterWeb, :view
  alias TwitterWeb.Api.TweetView

  def render("index.json", %{tweets: tweets}) do
    %{data: render_many(tweets, TweetView, "tweet.json")}
  end

  def render("show.json", %{tweet: tweet}) do
    %{data: render_one(tweet, TweetView, "tweet.json")}
  end

  def render("tweet.json", %{tweet: tweet}) do
    %{
      id: tweet.id,
      title: tweet.title,
      body: tweet.body,
      author: tweet.user_id
    }
  end
end
