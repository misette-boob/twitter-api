defmodule TwitterWeb.CartView do
  use TwitterWeb, :view

  alias Twitter.ShoppingCart

  def currency_to_str(%Decimal{} = val), do: "$#{Decimal.round(val, 2)}"
end