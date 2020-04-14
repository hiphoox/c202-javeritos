defmodule CodeGenerator do


  def generate_code(ast) do
    code = post_order(ast)
    code
  end

  def post_order(node) do
    case node do
      nil ->
        nil

      ast_node ->
        code_snippet = post_order(ast_node.left_node)
        post_order(ast_node.right_node)
        emit_code(ast_node.node_name, code_snippet, ast_node.value)
    end
  end

  @spec emit_code(:constant | :function | :program | :return, any, any) :: <<_::8, _::_*8>>
  def emit_code(:program, code_snippet, _) do
    """
        .section        __TEXT,__text,regular,pure_instructions
        .p2align        4, 0x90
    """ <>
      code_snippet
  end

  def emit_code(:function, code_snippet, :main) do
    """
        .globl  _main         ## -- Begin function main
    _main:                    ## @main
    """ <>
      code_snippet
  end

  def emit_code(:return, code_snippet, _) do
    code_snippet <>
    """
        ret
    """
  end

  def emit_code(:constant, _code_snippet, value) do
    """
    movl    #{value}, %eax
    """
  end

  def emit_code(:unary, code_snippet, :negation) do
    code_snippet <>
      """
      neg    %eax
      """
  end

  def emit_code(:unary, code_snippet, :logicalNeg) do
    code_snippet <>
      """
      cmpl   $0, %eax
      movl   $0, %eax
      sete   %al
      """
  end

  def emit_code(:unary, code_snippet, :bitWise) do
    code_snippet <>
      """
      not    %rax
      """
  end
end
