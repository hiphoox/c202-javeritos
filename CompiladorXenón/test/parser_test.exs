defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  test "Multi_digit" do
    ast= Lexer.lexing("int main() {
    return 100;
    }
    ")
    assert Parser.parse_program(ast) ==
      %AST{left_node:
        %AST{left_node:
          %AST{left_node:
            %AST{left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 100},
            node_name: :return,
            right_node: nil,
            value: :return},
          node_name: :function,
          right_node: nil,
          value: :main},
        node_name: :program,
        right_node: nil,
        value: nil}
  end

  test "Wrong Case" do
    ast= Lexer.lexing("int main() {
    RETURN 0;
}")
    assert Parser.parse_program(ast) == {:error, "*********ERROR AT 2: return keyword missed"}

  end

  test "falta parentesis" do
    ast= Lexer.lexing("int main( {
    return 0;
}")
    assert Parser.parse_program(ast) ==  {:error, "*********ERROR AT 1: close parentesis missed "}

  end


  test "falta value retorno" do
    ast= Lexer.lexing("int main() {
    return ;
}")
    assert Parser.parse_program(ast) ==  {:error, "*********ERROR AT 2: expect an int value"}
  end


  test "sin espacios" do
    ast= Lexer.lexing("int main() {
    return0;
    }")
    assert Parser.parse_program(ast) == {:error, "*********ERROR AT 2: return keyword missed"}
    end

  test "con lineas" do
    ast= Lexer.lexing("int main ()
    {
      return 0;
    }")
    assert Parser.parse_program(ast) ==
    %AST{left_node:
      %AST{left_node:
        %AST{left_node:
          %AST{left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 0},
          node_name: :return,
          right_node: nil,
          value: :return},
        node_name: :function,
        right_node: nil,
        value: :main},
      node_name: :program,
      right_node: nil,
      value: nil}
  end

  test "no brace" do
    ast= Lexer.lexing("int main()  return 0;}")
    assert Parser.parse_program(ast) == {:error, "*********ERROR AT 1: open brace missed "}
  end

  test "no semicolon" do
    ast= Lexer.lexing("int main() { return 0 }")
    assert Parser.parse_program(ast) == {:error, "*********ERROR AT 1: semicolon missed after constant to finish return statement "}
  end

  test "una linea" do
    ast= Lexer.lexing("int main(){return 0;}")
    assert Parser.parse_program(ast) ==
    %AST{left_node:
      %AST{left_node:
        %AST{left_node:
          %AST{left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 0},
          node_name: :return,
          right_node: nil,
          value: :return},
        node_name: :function,
        right_node: nil,
        value: :main},
      node_name: :program,
      right_node: nil,
      value: nil}
  end

  test "return 0" do
    ast= Lexer.lexing("int main() {
    return 0;
  }")
  assert Parser.parse_program(ast) ==
  %AST{
    left_node:
      %AST{left_node:
        %AST{left_node:
          %AST{left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 0},
          node_name: :return,
        right_node: nil,
        value: :return},
      node_name: :function,
      right_node: nil,
      value: :main},
    node_name: :program,
    right_node: nil,
    value: nil}
  end

  test "con espacios" do
    ast= Lexer.lexing("int   main    (  )  {   return  0 ; }")
    assert Parser.parse_program(ast) ==
    %AST{left_node:
      %AST{left_node:
        %AST{left_node:
          %AST{left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 0},
          node_name: :return,
          right_node: nil,
          value: :return},
        node_name: :function,
        right_node: nil,
        value: :main},
      node_name: :program,
      right_node: nil,
      value: nil}
  end
end
