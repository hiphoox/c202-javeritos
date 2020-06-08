defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer
    test "pruebaTest" do
      ast= Lexer.lexing("int main() {
        return 100;
        }
        ")
      assert ast==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 100},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end

    test "no Semicolon" do
    tlist=Lexer.lexing("int main(){
      return 100
    }")
    assert tlist==
    [
      {:type, 1, [:intKeyWord]},
      {:ident, 1, [:mainKeyWord]},
      {:lParen, 1, []},
      {:rParen, 1, []},
      {:lBrace, 1, []},
      {:ident, 2, [:returnKeyWord]},
      {:num, 2, 100},
      {:rBrace, 3, []}
    ]
  end
  test "no constant" do
    tlist=Lexer.lexing("int main(){
      return ;
    }")
    assert tlist==
    [
      {:type, 1, [:intKeyWord]},
      {:ident, 1, [:mainKeyWord]},
      {:lParen, 1, []},
      {:rParen, 1, []},
      {:lBrace, 1, []},
      {:ident, 2, [:returnKeyWord]},
      {:semicolon, 2, []},
      {:rBrace, 3, []}
    ]
  end
  test "wrong case" do
    tlist=Lexer.lexing("int main() {
      RETURN 0;
}")
    assert tlist==
    [
      {:type, 1, [:intKeyWord]},
      {:ident, 1, [:mainKeyWord]},
      {:lParen, 1, []},
      {:rParen, 1, []},
      {:lBrace, 1, []},
      {:string, 2, ["RETURN"]},
      {:num, 2, 0},
      {:semicolon, 2, []},
      {:rBrace, 3, []}
    ]

  end

  end

