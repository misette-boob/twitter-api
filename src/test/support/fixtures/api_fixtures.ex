defmodule Twitter.APIFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitter.Api` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{

      })
      |> Twitter.Api.create_user()

    user
  end
end
