defmodule CondParserJsonTest do
  use ExUnit.Case
  doctest CondParser

  test "\":foo\" == 12" do
    assert CondParser.to_json("\":foo\" == 12") ==
             {:ok, %{"left" => ":foo", "op" => "eq", "right" => 12}}
  end

  test "\':foo\' != true" do
    assert CondParser.to_json("\':foo\' != true") ==
             {:ok, %{"left" => ":foo", "op" => "not_eq", "right" => true}}
  end

  test "\':foo\' != 12.5 OR true" do
    assert CondParser.to_json("\':foo\' != 12.5 OR true") ==
             {:ok,
              %{
                "left" => %{"left" => ":foo", "op" => "not_eq", "right" => 12.5},
                "op" => "or",
                "right" => true
              }}
  end

  test "\':foo\'" do
    assert CondParser.to_json("\':foo\'") ==
             {:ok, %{"left" => ":foo"}}
  end

  test "\':foo\' == \"toto\" and true" do
    assert CondParser.to_json("\':foo\' == \"toto\" and true") ==
             {:ok,
              %{
                "left" => %{"left" => ":foo", "op" => "eq", "right" => "toto"},
                "op" => "and",
                "right" => true
              }}
  end

  test "\':foo\' or \"toto\" and true" do
    assert CondParser.to_json("\':foo\' or \"toto\" and true") ==
             {:ok,
              %{
                "left" => ":foo",
                "op" => "or",
                "right" => %{"left" => "toto", "op" => "and", "right" => true}
              }}
  end

  test "(\':foo\' or \"toto\") and true" do
    assert CondParser.to_json("(\':foo\' or \"toto\") and true") ==
             {:ok,
              %{
                "left" => %{"left" => ":foo", "op" => "or", "right" => "toto"},
                "op" => "and",
                "right" => true
              }}
  end

  test "(\':foo\' or (\"toto\" == true AND (12 != 13 OR false))) and true" do
    assert CondParser.to_json("(\':foo\' or (\"toto\" == true AND (12 != 13 OR false))) and true") ==
             {:ok,
              %{
                "left" => %{
                  "left" => ":foo",
                  "op" => "or",
                  "right" => %{
                    "left" => %{"left" => "toto", "op" => "eq", "right" => true},
                    "op" => "and",
                    "right" => %{
                      "left" => %{"left" => 12, "op" => "not_eq", "right" => 13},
                      "op" => "or",
                      "right" => false
                    }
                  }
                },
                "op" => "and",
                "right" => true
              }}
  end
end
