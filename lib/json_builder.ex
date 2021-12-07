defmodule JsonBuilder do
  def build({_op, _left, _right} = ast), do: build_(ast)
  def build(value), do: %{"left" => value}

  def build_({:or_op, left, right}) do
    %{"left" => build_(left), "op" => "or", "right" => build_(right)}
  end

  def build_({:and_op, left, right}) do
    %{"left" => build_(left), "op" => "and", "right" => build_(right)}
  end

  def build_({:eq_op, left, right}) do
    %{"left" => build_(left), "op" => "eq", "right" => build_(right)}
  end

  def build_({:not_eq_op, left, right}) do
    %{"left" => build_(left), "op" => "not_eq", "right" => build_(right)}
  end

  def build_(value), do: value
end
