defmodule TwitterWeb.Api.CommentController do
  use TwitterWeb, :controller

  alias Twitter.Blog
  alias Twitter.Blog.Comment

  action_fallback TwitterWeb.FallbackController

  def index(conn, params) do
    comments = Blog.list_comments(params)
    render(conn, "index.json", comments: comments)
  end

  def show(conn, %{"id" => id}) do
    comment = Blog.get_comment(id)
    render(conn, "show.json", comment: comment)
  end

  # %{"comment" => %{"body" => "voluptatum ad facilis"}, "tweet_id" => "1"}

  def create(conn, %{"tweet_id" => tweet_id, "comment" => comment_params}) do
    tweet = Blog.get_tweet!(tweet_id)
    author = conn.assigns.current_user

    with {:ok, %Comment{} = comment} <- Blog.create_comment(author, tweet, comment_params) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Blog.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Blog.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)

    with {:ok, %Comment{}} <- Blog.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
