defmodule TwitterWeb.ProductView do
  use TwitterWeb, :view

  def category_select(f, changeset) do
    existing_ids = changeset |> Ecto.Changeset.get_change(:categories, []) |> Enum.map(& &1.data.id)

    category_opts =
      for cat <- Twitter.Catalog.list_categories(),
          do: [key: cat.title, value: cat.id, selected: cat.id in existing_ids]

    multiple_select(f, :category_ids, category_opts)
  end
end
