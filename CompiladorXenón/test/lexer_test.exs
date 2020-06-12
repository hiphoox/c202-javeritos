defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "pruebaTest" do
    ast = Lexer.lexing("int main() {
        return 100;
        }
        ")

    assert ast == [
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
    tlist = Lexer.lexing("int main(){
      return 100
    }")

    assert tlist ==
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
    tlist = Lexer.lexing("int main(){
      return ;
    }")

    assert tlist ==
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
    tlist = Lexer.lexing("int main() {
      RETURN 0;
}")

    assert tlist ==
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

  test "random string" do
    tlist = Lexer.lexing("int main() {
                return asd;
        }")

    assert tlist == [
             {:type, 1, [:intKeyWord]},
             {:ident, 1, [:mainKeyWord]},
             {:lParen, 1, []},
             {:rParen, 1, []},
             {:lBrace, 1, []},
             {:ident, 2, [:returnKeyWord]},
             {:string, 2, ["asd"]},
             {:semicolon, 2, []},
             {:rBrace, 3, []}
           ]
  end

  test "garbage and unordered" do
    tlist = Lexer.lexing("writing a bunch of garbage
        unidintifiable tokens
        main ()
        perhaps a return here
        and finally a ;")

    assert tlist == [
             {:string, 1, ["writing"]},
             {:string, 1, ["a"]},
             {:string, 1, ["bunch"]},
             {:string, 1, ["of"]},
             {:string, 1, ["garbage"]},
             {:string, 2, ["unidintifiable"]},
             {:string, 2, ["tokens"]},
             {:ident, 3, [:mainKeyWord]},
             {:lParen, 3, []},
             {:rParen, 3, []},
             {:string, 4, ["perhaps"]},
             {:string, 4, ["a"]},
             {:ident, 4, [:returnKeyWord]},
             {:string, 4, ["here"]},
             {:string, 5, ["and"]},
             {:string, 5, ["finally"]},
             {:string, 5, ["a"]},
             {:semicolon, 5, []}
           ]
  end

  test "unary " do
    tlist = Lexer.lexing("int main(){
          return -1;
        }")

    assert tlist == [
             {:type, 1, [:intKeyWord]},
             {:ident, 1, [:mainKeyWord]},
             {:lParen, 1, []},
             {:rParen, 1, []},
             {:lBrace, 1, []},
             {:ident, 2, [:returnKeyWord]},
             {:operator, 2, [:negation]},
             {:num, 2, 1},
             {:semicolon, 2, []},
             {:rBrace, 3, []}
           ]
  end

  test "unarybitw" do
    tlist = Lexer.lexing("int main(){
          return ~1;
        }")

    assert tlist == [
             {:type, 1, [:intKeyWord]},
             {:ident, 1, [:mainKeyWord]},
             {:lParen, 1, []},
             {:rParen, 1, []},
             {:lBrace, 1, []},
             {:ident, 2, [:returnKeyWord]},
             {:operator, 2, [:bitWise]},
             {:num, 2, 1},
             {:semicolon, 2, []},
             {:rBrace, 3, []}
           ]
  end
    test "logical!" do
      tlist=Lexer.lexing(
        "int main(){
          return ! 1;
        }"
      )
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:operator, 2, [:logicalNeg]},
        {:num, 2, 1},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
    test "sum recognizition" do
      tlist=Lexer.lexing("int main(){
        return 1+2;
      }")
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:addition]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
    test "minus recognizition" do
      tlist=Lexer.lexing("int main(){
        return 1-2;
      }")
      assert tlist== [
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:negation]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
      test "multiplication recogniciance" do
        tlist=Lexer.lexing("int main(){
          return 1*2;
        }")
        assert tlist==[
          {:type, 1, [:intKeyWord]},
          {:ident, 1, [:mainKeyWord]},
          {:lParen, 1, []},
          {:rParen, 1, []},
          {:lBrace, 1, []},
          {:ident, 2, [:returnKeyWord]},
          {:num, 2, 1},
          {:operator, 2, [:multiplication]},
          {:num, 2, 2},
          {:semicolon, 2, []},
          {:rBrace, 3, []}
        ]
    end
    test "divisition recog." do
      tlist=Lexer.lexing ("int main(){
        return 1/2;
      }")
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:division]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
    test "logicalAnd" do
      tlist=Lexer.lexing ("int main(){
        return 1&&2;
      }")
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:logicalAnd]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
    test "logicalOr Recog." do
      tlist=Lexer.lexing("int main(){
        return 1||2;
      }")
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:orlog]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
    test "equal to recog" do
      tlist=Lexer.lexing("int main(){
        return 1==2;
      }")
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:EqualTo]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
    test "greater than recog." do
      tlist=Lexer.lexing("int main(){
        return 1> 2;
      }")
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:Greather]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
    test "less than" do
      tlist=Lexer.lexing("int main(){
        return 1< 2;
      }")
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:LessThan]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
    test "less or equal recog" do
      tlist=Lexer.lexing("int main(){
        return 1<=2;
      }")
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:LessOrEqual]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
    test "greater or equal than recog" do
      tlist=Lexer.lexing("int main(){
        return 1>=2;
      }")
      assert tlist==[
        {:type, 1, [:intKeyWord]},
        {:ident, 1, [:mainKeyWord]},
        {:lParen, 1, []},
        {:rParen, 1, []},
        {:lBrace, 1, []},
        {:ident, 2, [:returnKeyWord]},
        {:num, 2, 1},
        {:operator, 2, [:GreatherOrEqual]},
        {:num, 2, 2},
        {:semicolon, 2, []},
        {:rBrace, 3, []}
      ]
    end
end
