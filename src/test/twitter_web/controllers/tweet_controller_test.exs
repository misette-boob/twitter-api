defmodule TwitterWeb.TweetControllerTest do
  use TwitterWeb.ConnCase

  import Twitter.BlogFixtures

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  describe "index" do
    test "lists all tweets", %{conn: conn} do
      conn = get(conn, Routes.tweet_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tweets"
    end
  end

  describe "new tweet" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tweet_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tweet"
    end
  end

  describe "create tweet" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tweet_path(conn, :show, id)

      conn = get(conn, Routes.tweet_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tweet"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tweet_path(conn, :create), tweet: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tweet"
    end
  end

  describe "edit tweet" do
    setup [:create_tweet]

    test "renders form for editing chosen tweet", %{conn: conn, tweet: tweet} do
      conn = get(conn, Routes.tweet_path(conn, :edit, tweet))
      assert html_response(conn, 200) =~ "Edit Tweet"
    end
  end

  describe "update tweet" do
    setup [:create_tweet]

    test "redirects when data is valid", %{conn: conn, tweet: tweet} do
      conn = put(conn, Routes.tweet_path(conn, :update, tweet), tweet: @update_attrs)
      assert redirected_to(conn) == Routes.tweet_path(conn, :show, tweet)

      conn = get(conn, Routes.tweet_path(conn, :show, tweet))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, tweet: tweet} do
      conn = put(conn, Routes.tweet_path(conn, :update, tweet), tweet: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tweet"
    end
  end

  describe "delete tweet" do
    setup [:create_tweet]

    test "deletes chosen tweet", %{conn: conn, tweet: tweet} do
      conn = delete(conn, Routes.tweet_path(conn, :delete, tweet))
      assert redirected_to(conn) == Routes.tweet_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.tweet_path(conn, :show, tweet))
      end
    end
  end

  defp create_tweet(_) do
    tweet = tweet_fixture()
    %{tweet: tweet}
  end
end
