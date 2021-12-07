defmodule CondParserTest do
  use ExUnit.Case
  doctest CondParser

  test "\":foo\" == 12" do
    assert CondParser.parse("\":foo\" == 12") ==
             {:ok, {:eq_op, ":foo", 12}}
  end

  test "\':foo\' != true" do
    assert CondParser.parse("\':foo\' != true") ==
             {:ok, {:not_eq_op, ":foo", true}}
  end

  test "\':foo\' != 12.5 OR true" do
    assert CondParser.parse("\':foo\' != 12.5 OR true") ==
             {:ok, {:or_op, {:not_eq_op, ":foo", 12.5}, true}}
  end

  test "\':foo\'" do
    assert CondParser.parse("\':foo\'") ==
             {:ok, ":foo"}
  end

  test "\':foo\' == \"toto\" and true" do
    assert CondParser.parse("\':foo\' == \"toto\" and true") ==
             {:ok, {:and_op, {:eq_op, ":foo", "toto"}, true}}
  end

  test "\':foo\' or \"toto\" and true" do
    assert CondParser.parse("\':foo\' or \"toto\" and true") ==
             {:ok, {:or_op, ":foo", {:and_op, "toto", true}}}
  end

  test "(\':foo\' or \"toto\") and true" do
    assert CondParser.parse("(\':foo\' or \"toto\") and true") ==
             {:ok, {:and_op, {:or_op, ":foo", "toto"}, true}}
  end

  test "(\':foo\' or (\"toto\" == true AND (12 != 13 OR false))) and true" do
    assert CondParser.parse("(\':foo\' or (\"toto\" == true AND (12 != 13 OR false))) and true") ==
             {:ok,
              {:and_op,
               {:or_op, ":foo",
                {:and_op, {:eq_op, "toto", true}, {:or_op, {:not_eq_op, 12, 13}, false}}}, true}}
  end
end
