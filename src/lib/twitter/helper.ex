defmodule Twitter.Helper do
  def maybe_to_int(value) do
    unless is_integer(value) do
      {int, _} = Integer.parse(value)
      int
    else
      value
    end
  end
end