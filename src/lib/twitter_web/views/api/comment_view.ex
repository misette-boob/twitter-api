defmodule TwitterWeb.Api.CommentView do
  use TwitterWeb, :view
  alias TwitterWeb.Api.CommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      body: comment.body,
      author_id: comment.user_id,
      tweet_id: comment.tweet_id
    }
  end
end
