defmodule Twitter.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Twitter.Catalog` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        price: "120.5",
        title: "some title",
        views: 42
      })
      |> Twitter.Catalog.create_product()

    product
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Twitter.Catalog.create_category()

    category
  end
end
