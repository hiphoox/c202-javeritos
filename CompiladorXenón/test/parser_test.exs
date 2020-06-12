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
    return ! 12;
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
    return ! -3;
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
    return ! 5;
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
    return ! 0;
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

test "missing const" do
  ast= Lexer.lexing("int main() {
  return ! ;
  }")
  assert Parser.parse_program(ast) == {:error, "*********ERROR AT 2: expect an int value"}
end

test "missing semicolon" do
  ast= Lexer.lexing("int main() {
  return ! 5
  }")
  assert Parser.parse_program(ast) == {:error,
           "*********ERROR AT 3: semicolon missed after constant to finish return statement "}
end

test "nested missing const" do
  ast= Lexer.lexing("int main() {
  return ! ~;
  }")
  assert Parser.parse_program(ast) ==  {:error, "*********ERROR AT 2: expect an int value"}
end


test "wrong order" do
  ast= Lexer.lexing("int main() {
  return 4-;
  }")

  assert Parser.parse_program(ast) == {:error, "*********ERROR AT 2: expect an int value"}
end



#BINARIES

test "unop_parens" do
  ast= Lexer.lexing("int main() {
    return ~(1 + 1);
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
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              value: :addition
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

test "unop_add" do
  ast= Lexer.lexing("int main() {
    return ~2 + 3;
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
                value: 2
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 3
              },
              value: :addition
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

test "sub_neg" do
  ast= Lexer.lexing("int main() {
    return 2- -1;
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
              value: 2
            },
            node_name: :binary,
            right_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :unary,
              right_node: nil,
              value: :negation
            },
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

test "sub" do
  ast= Lexer.lexing("int main() {
    return 1 - 2;
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
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
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

test "precedence_S" do
  ast= Lexer.lexing("int main() {
    return 2 + 3 * 4;
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
              value: 2
            },
            node_name: :binary,
            right_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 3
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 4
              },
              value: :multiplication
            },
            value: :addition
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

test "parens" do
  ast= Lexer.lexing("int main() {
    return 2 * (3 + 4);
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
              value: 2
            },
            node_name: :binary,
            right_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 3
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 4
              },
              value: :addition
            },
            value: :multiplication
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

test "mult" do
  ast= Lexer.lexing("int main() {
    return 2 * 3;
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
              value: 2
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 3
            },
            value: :multiplication
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


test "div" do
  ast= Lexer.lexing("int main() {
    return 4 / 2;
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
              value: 4
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            value: :division
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

test "div_neg" do
  ast= Lexer.lexing("  int main() {
    return (-12) / 5;
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
                value: 12
              },
              node_name: :unary,
              right_node: nil,
              value: :negation
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 5
            },
            value: :division
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

test "associativity_2" do
  ast= Lexer.lexing("int main() {
    return 6 / 3 / 2;
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
              value: 6
            },
            node_name: :binary,
            right_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 3
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              value: :division
            },
            value: :division
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

test "add" do
  ast= Lexer.lexing("int main() {
    return 1 + 2;
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
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            value: :addition
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

#BINARIES TO FAIL

test "no_semicolon" do
  ast= Lexer.lexing("int main() {
    return 2*2
  }")

  assert Parser.parse_program(ast) ==
    {:error,
    "*********ERROR AT 3: semicolon missed after constant to finish return statement "}
end

test "missig_second_op" do
  ast= Lexer.lexing("int main() {
    return 1 + ;
  }")
  assert Parser.parse_program(ast) ==
    {:error, "*********ERROR AT 2: expect an int value"}
end

test "missing_first_op" do
  ast= Lexer.lexing("int main() {
    return /3;
  }")
  assert Parser.parse_program(ast) ==
    {:error, "*********ERROR AT 2: expect an unary expression"}
end

test "mmalformed_paren" do
  ast= Lexer.lexing("int main() {
    return 2 (- 3);
  }")
  assert Parser.parse_program(ast) ==
    {:error,
      "*********ERROR AT 2: semicolon missed after constant to finish return statement "}
end


#Stage 4

test "and_false" do
  ast= Lexer.lexing("int main() {
    return 1 && 0;
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
            value: 1
          },
          node_name: :binary,
          right_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 0
          },
          value: :logicalAnd
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

test "and_true" do
  ast= Lexer.lexing("int main() {
    return 1 && -1;
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
            value: 1
          },
          node_name: :binary,
          right_node: %AST{
            left_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 1
            },
            node_name: :unary,
            right_node: nil,
            value: :negation
          },
          value: :logicalAnd
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

  test "eq_false" do
    ast= Lexer.lexing("int main(){
      return 1 == 2;
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
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            value: :EqualTo
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


  test "eq_true" do
    ast= Lexer.lexing("int main() {
      return 1 == 1;
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
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 1
            },
            value: :EqualTo
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

  test "ge_false" do
    ast= Lexer.lexing("int main() {
    return 1>=2;
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
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            value: :GreatherOrEqual
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


  test "ge_true" do
    ast= Lexer.lexing("int main() {
    return 1 >= 1;
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
            value: 1
          },
          node_name: :binary,
          right_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 1
          },
          value: :GreatherOrEqual
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

  test "gt_false" do
    ast= Lexer.lexing("int main() {
    return 1 > 2;
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
            value: 1
          },
          node_name: :binary,
          right_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 2
          },
          value: :Greather
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


  test "gt_true" do
    ast= Lexer.lexing("int main() {
    return 1 > 0;
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
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0
            },
            value: :Greather
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





  test "le_false" do
    ast= Lexer.lexing("int main() {
    return 1 <= -1;
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
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 1
              },
              node_name: :unary,
              right_node: nil,
              value: :negation
            },
            value: :LessOrEqual
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


  test "le_true" do
    ast= Lexer.lexing("int main() {
    return 0 <= 2;
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
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 2
            },
            value: :LessOrEqual
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

test "lt_false" do
  ast= Lexer.lexing("int main() {
    return 2 < 1;
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
            value: 2
          },
          node_name: :binary,
          right_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 1
          },
          value: :LessThan
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

test "lt_true" do
  ast= Lexer.lexing("int main() {
    return 1 < 2;
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
            value: 1
          },
          node_name: :binary,
          right_node: %AST{
            left_node: nil,
            node_name: :constant,
            right_node: nil,
            value: 2
          },
          value: :LessThan
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


  test "or_false" do
    ast= Lexer.lexing("int main() {
    return 0 || 0;
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
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0
            },
            value: :orlog
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

  test "or_true" do
    ast= Lexer.lexing("int main() {
    return 1 || 0;
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
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0
            },
            value: :orlog
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


  test "precedence" do
    ast= Lexer.lexing("int main() {
    return 1 || 0 && 2;
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
              value: 1
            },
            node_name: :binary,
            right_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              value: :logicalAnd
            },
            value: :orlog
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

  test "precedence_2" do
    ast= Lexer.lexing("int main() {
    return (1 || 0) && 0;
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
                value: 1
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              value: :orlog
            },
            node_name: :binary,
            right_node: %AST{
              left_node: nil,
              node_name: :constant,
              right_node: nil,
              value: 0
            },
            value: :logicalAnd
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


  test "precedence_3" do
    ast= Lexer.lexing("int main() {
    return 2 == 2 > 0;
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
              value: 2
            },
            node_name: :binary,
            right_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              value: :Greather
            },
            value: :EqualTo
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


  test "precedence_4" do
    ast= Lexer.lexing("int main() {
    return 2 == 2 || 0;
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
              value: 2
            },
            node_name: :binary,
            right_node: %AST{
              left_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 2
              },
              node_name: :binary,
              right_node: %AST{
                left_node: nil,
                node_name: :constant,
                right_node: nil,
                value: 0
              },
              value: :orlog
            },
            value: :EqualTo
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

  test "missing_first_op4" do
    ast= Lexer.lexing("int main() {
    return <= 2;
    }")

    assert Parser.parse_program(ast) ==
    {:error, "*********ERROR AT 2: expect an unary expression"}

  end

  test "missing_mid_op" do
    ast= Lexer.lexing("int main() {
    return 1 < > 3;
    }")

    assert Parser.parse_program(ast) ==
    {:error, "*********ERROR AT 2: expect an unary expression"}

  end

  test "missing_second_op" do
    ast= Lexer.lexing("int main() {
    return 2 &&
    }")

    assert Parser.parse_program(ast) ==
    {:error, "*********ERROR AT 3: expect an int value"}

  end

    test "missing_semicolon_4" do
    ast= Lexer.lexing("int main() {
    return 1 || 2
    }")

    assert Parser.parse_program(ast) ==
    {:error, "*********ERROR AT 3: semicolon missed after constant to finish return statement "}
  end






end
