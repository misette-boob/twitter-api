defmodule TwitterWeb.CartItemController do
  use TwitterWeb, :controller

  alias Twitter.{ShoppingCart, Catalog}

  def create(conn, %{"product_id" => product_id}) do
    product = Catalog.get_product!(product_id)

    case ShoppingCart.add_item_to_cart(conn.assigns.cart, product) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item added to your cart")
        |> redirect(to: Routes.cart_path(conn, :show))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "There was an error adding the item to your cart")
        |> redirect(to: Routes.cart_path(conn, :show))
    end
  end

  def delete(conn, %{"id" => product_id}) do
    {:ok, _cart} = ShoppingCart.remove_item_from_cart(conn.assigns.cart, product_id)
    redirect(conn, to: Routes.cart_path(conn, :show))
  end
end