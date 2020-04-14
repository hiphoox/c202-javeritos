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


#UNARIOS TO PASS

test "BIT WISE" do
  ast= Lexer.lexing("int main() {
  return !12;
  }")
  assert Parser.parse_program(ast) ==
  %AST{
    left_node: %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 12
          },
          node_name: :unary,
          right_node: nil,
          value: :logicalNeg
        },
        node_name: :return,
        right_node: nil,
        value: :return
      },
      node_name: :function,
      right_node: nil,
      value: :main
    },
    node_name: :program,
    right_node: nil,
    value: nil
  }
  end

  test "BIT WISE ZERO" do
    ast= Lexer.lexing("int main() {
      return ~0;
      }")
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0
            },
            node_name: :unary,
            right_node: nil,
            value: :bitWise
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "NEG" do
    ast= Lexer.lexing("int main() {
      return -5;
      }")
    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 5
            },
            node_name: :unary,
            right_node: nil,
            value: :negation
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "nested_ops" do
    ast= Lexer.lexing("int main() {
    return !-3;
    }")

    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 3
              },
              node_name: :unary,
              right_node: nil,
              value: :negation
            },
            node_name: :unary,
            right_node: nil,
            value: :logicalNeg
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "nested_ops_2" do
    ast= Lexer.lexing("int main() {
    return -~0;
    }")

    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              node_name: :unary,
              right_node: nil,
              value: :bitWise
            },
            node_name: :unary,
            right_node: nil,
            value: :negation
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "not five" do
    ast= Lexer.lexing("int main() {
    return !5;
    }")

    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 5
            },
            node_name: :unary,
            right_node: nil,
            value: :logicalNeg
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end

  test "not zero" do
    ast= Lexer.lexing("int main() {
    return !0;
    }")

    assert Parser.parse_program(ast) ==
    %AST{
      left_node: %AST{
        left_node: %AST{
          left_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0
            },
            node_name: :unary,
            right_node: nil,
            value: :logicalNeg
          },
          node_name: :return,
          right_node: nil,
          value: :return
        },
        node_name: :function,
        right_node: nil,
        value: :main
      },
      node_name: :program,
      right_node: nil,
      value: nil
    }
  end


#OPERADORES UNARIO INVALIDOS



end
