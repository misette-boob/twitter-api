defmodule TwitterWeb.Api.TweetView do
  use TwitterWeb, :view

  alias TwitterWeb.Api.TweetView
  alias TwitterWeb.Api.CommentView

  def render("index.json", %{tweets: tweets}) do
    %{data: render_many(tweets, TweetView, "tweet.json")}
  end

  def render("show.json", %{tweet: tweet}) do
    %{data: render_one(tweet, TweetView, "tweet.json")}
  end

  def render("show_with_comments.json", %{tweet: tweet}) do
    tweet_json = render("tweet.json", %{tweet: tweet})
    %{data: Map.put_new(tweet_json, :comments, render_many(tweet.comments, CommentView, "comment.json"))}
  end

  def render("tweet.json", %{tweet: tweet}) do
    %{
      id: tweet.id,
      title: tweet.title,
      body: tweet.body,
      author_id: tweet.user_id
    }
  end
end
