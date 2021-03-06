defmodule CodeGenerator do


  def generate_code(ast) do
    code = post_order(ast," ")
    code
  end

  def post_order(node, code_snippet) do
    case node do
      nil ->
        ""

      ast_node ->

        if ast_node.node_name == :constant do
          emit_code(:constant, code_snippet, ast_node.value)
        else

          emit_code(
            ast_node.node_name,
            post_order(ast_node.left_node, code_snippet) <>
            pushOp(ast_node) <>
            post_order(ast_node.right_node, code_snippet) <>
            popOp(ast_node),
            ast_node.value
            )

        end
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



  # OPERADORES BINARIOS

  def emit_code(:binary, code_snippet, :addition) do
    code_snippet <>
      """
      pop     %rax
      add     %rax, %rcx
      """
  end

  def emit_code(:binary, code_snippet, :negation) do
    code_snippet <>
      """
      sub    %rax, %rbx
      mov    %rbx, %rax
      """
  end

  def emit_code(:binary, code_snippet, :multiplication) do
    code_snippet <>
      """
      imul   %rbx, %rax
      """
  end

  def emit_code(:binary, code_snippet, :division) do
    code_snippet <>
      """
      push   %rax
      mov    %rbx, %rax
      pop    %rbx
      cqo
      idivq  %rbx
      """
  end

  def emit_code(:binary, code_snippet, :EqualTo) do
    code_snippet <>
      """
      push %rax
      pop %rbx
      cmp %rax, %rbx
      mov $0, %rax
      sete %al
      """
  end

  def emit_code(:binary, code_snippet, :NotEqual) do
    code_snippet <>
      """
                      push %rax
                      pop %rbx
                      cmp %rax, %rbx
                      mov $0, %rax
                      setne %al
      """
  end

  def emit_code(:binary, code_snippet, :GreatherOrEqual) do
    code_snippet <>
      """
             
                      push %rax
                      pop %rbx
                      cmp %rax, %rbx
                      mov $0, %rax
                      setge %al
      """
  end

  def emit_code(:binary, code_snippet, :Greather) do
    code_snippet <>
      """
                      push %rax
                      pop %rbx
                      cmp %rax, %rbx
                      mov $0, %rax
                      setg %al
      """
  end

  def emit_code(:binary, code_snippet, :LessThan) do
    code_snippet <>
      """

                      push %rax
                      pop %rbx
                      cmp %rax, %rbx
                      mov $0, %rax
                      setl %al
      """
  end

  def emit_code(:binary, code_snippet, :LessOrEqual) do
    code_snippet <>
      """
                      push %rax
                      pop %rbx
                      cmp %rax, %rbx
                      mov $0, %rax
                      setle %al
      """
  end

  def emit_code(:binary, code_snippet, :orlog) do
    lista_1 = Regex.scan(~r/clause_or\d{1,}/, code_snippet)
    lista_2 = Regex.scan(~r/clause_or\d{1,}/, code_snippet)
    num = Integer.to_string(length(lista_1) + length(lista_2) + 1)

    code_snippet <>
      """
                      cmp $0, %rax
                      je clause_or#{num}
                      mov $1,%rax
                      jmp end_or#{num}
                  clause_or#{num}:
                      cmp $0, %rax
                      mov $0, %rax
                      setne %al
                  end_or#{num}:
      """
  end

  def emit_code(:binary, code_snippet, :logicalAnd) do
    lista_1 = Regex.scan(~r/clause_and\d{1,}/, code_snippet)
    lista_2 = Regex.scan(~r/clause_and\d{1,}/, code_snippet)
    num = Integer.to_string(length(lista_1) + length(lista_2) + 1)

    code_snippet <>
      """
                      cmp $0, %rax
                      jne clause_and#{num}
                      jmp end_and#{num}
                  clause_and#{num}:
                      cmp $0, %rax
                      mov $0, %rax
                      setne %al
                  end_and#{num}:
      """
  end



  def pushOp(ast_node) do

      if ast_node.node_name == :unary and ast_node.value == :negation and ast_node.right_node == nil do
        """
        _NEG
        """
      else
        """
        push    %rax
        """
      end
  end

  def popOp(ast_node) do

      if ast_node.node_name == :unary and ast_node.value == :negation and ast_node.right_node == nil do
        ""
      else
        """
        pop    %rbx
        """
      end
  end
end
