defmodule CondParser do
  @moduledoc """
  `CondParser` reads conditions like
  `(':foo' or ("toto" == true AND (12 != 13 OR false))) and true` and transform them
  either in an ast with `parse/1`, or in json with `to_json/1`.

  Ast looks like this:

  ```
  {:and_op,
    {:or_op, ":foo",
      {:and_op,
        {:eq_op, "toto", true},
        {:or_op,
          {:not_eq_op, 12, 13},
          false
        }
      }
    },
    true
  }
  ```

  Json looks like this:

  ```json
  {
    "left": {
      "left": ":foo",
      "op": "or",
      "right": {
        "left": {"left": "toto", "op": "eq", "right": true},
        "op": "and",
        "right": {
          "left": {"left": 12, "op": "not_eq", "right": 13},
          "op": "or",
          "right": false
        }
      }
    },
    "op": "and",
    "right": true
  }
  ```
  """

  @type ast() :: any()
  @type json() :: map()

  @spec parse(binary) :: {:ok, ast()} | {:error, any()}
  def parse(str) do
    with {:ok, tokens, _end_line} <- str |> to_charlist() |> :cond_lexer.string(),
         {:ok, ast} <- :cond_parser.parse(tokens) do
      {:ok, ast}
    else
      {_, reason, _} ->
        {:error, reason}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec parse!(binary) :: ast
  def parse!(str) do
    case parse(str) do
      {:ok, ast} -> ast
      {:error, err} -> throw(err)
    end
  end

  @spec to_json(binary) :: {:error, any()} | {:ok, json()}
  def to_json(str) do
    case parse(str) do
      {:ok, ast} -> {:ok, JsonBuilder.build(ast)}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec to_json!(binary) :: json()
  def to_json!(str) do
    case to_json(str) do
      {:ok, json} -> json
      {:error, err} -> throw(err)
    end
  end

  @spec is_valid?(binary) :: boolean()
  def is_valid?(str) do
    case parse(str) do
      {:ok, _ast} -> true
      {:error, _err} -> false
    end
  end
end
