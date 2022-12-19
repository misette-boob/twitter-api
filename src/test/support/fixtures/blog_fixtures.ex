defmodule Twitter.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitter.Blog` context.
  """

  @doc """
  Generate a tweet.
  """
  def tweet_fixture(attrs \\ %{}) do
    {:ok, tweet} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })
      |> Twitter.Blog.create_tweet()

    tweet
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> Twitter.Blog.create_comment()

    comment
  end
end
