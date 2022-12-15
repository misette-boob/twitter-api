defmodule Twitter.BlogTest do
  use Twitter.DataCase

  alias Twitter.Blog

  describe "tweets" do
    alias Twitter.Blog.Tweet

    import Twitter.BlogFixtures

    @invalid_attrs %{body: nil, title: nil}

    test "list_tweets/0 returns all tweets" do
      tweet = tweet_fixture()
      assert Blog.list_tweets() == [tweet]
    end

    test "get_tweet!/1 returns the tweet with given id" do
      tweet = tweet_fixture()
      assert Blog.get_tweet!(tweet.id) == tweet
    end

    test "create_tweet/1 with valid data creates a tweet" do
      valid_attrs = %{body: "some body", title: "some title"}

      assert {:ok, %Tweet{} = tweet} = Blog.create_tweet(valid_attrs)
      assert tweet.body == "some body"
      assert tweet.title == "some title"
    end

    test "create_tweet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_tweet(@invalid_attrs)
    end

    test "update_tweet/2 with valid data updates the tweet" do
      tweet = tweet_fixture()
      update_attrs = %{body: "some updated body", title: "some updated title"}

      assert {:ok, %Tweet{} = tweet} = Blog.update_tweet(tweet, update_attrs)
      assert tweet.body == "some updated body"
      assert tweet.title == "some updated title"
    end

    test "update_tweet/2 with invalid data returns error changeset" do
      tweet = tweet_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_tweet(tweet, @invalid_attrs)
      assert tweet == Blog.get_tweet!(tweet.id)
    end

    test "delete_tweet/1 deletes the tweet" do
      tweet = tweet_fixture()
      assert {:ok, %Tweet{}} = Blog.delete_tweet(tweet)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_tweet!(tweet.id) end
    end

    test "change_tweet/1 returns a tweet changeset" do
      tweet = tweet_fixture()
      assert %Ecto.Changeset{} = Blog.change_tweet(tweet)
    end
  end
end
