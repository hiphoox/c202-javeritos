
defmodule GENERADOR do
  def generate_code(arbol) do
    post_order(arbol, "")
  end

  def post_order(node, code_snippet) do
    case node do
      nil ->
        ""

      anode ->
        # CHECA SI SÓLO ES CONSTANTE
        if anode.nodopadre == :constant do
          emit_code(:constant, code_snippet, anode.valor)
        else
          emit_code(
            anode.nodopadre,
            post_order(anode.hijoIzq, code_snippet) <>
              pushOp(anode) <>
              post_order(anode.hijoder, code_snippet) <> popOp(anode),
            anode.valor
          )
        end
    end
  end

  # obtiene op izq
  def pushOp(anode) do
    if operaBin(anode.nodopadre) do
      # Checa si el -es unario
      if anode.nodopadre == :unary_negation and anode.hijoder == nil do
        """
        _NEG
        """
      else
        """
        push    %rax
        """
      end
    else
      ""
    end
  end

  def popOp(anode) do
    if operaBin(anode.nodopadre) do
      # checa si - unario
      # operación
      if anode.nodopadre == :unary_negation and anode.hijoder == nil do
        ""
      else
        """
        pop    %rbx
        """
      end
    else
      ""
    end
  end

  # checar con nodo padre si es binario
  def operaBin(anodopadre) do
    if anodopadre do
      true
    end
  end

  def emit_code(:program, code_snippet, _) do
    """
    .section        __TEXT,__text,regular,pure_instructions
    .p2align        4, 0x90
    """ <>
      code_snippet
  end

  def emit_code(:funcion, code_snippet, :main) do
    """
    .globl  _main         ## -- Begin function main
    _main:                    ## @main
    """ <>
      code_snippet
  end

  def emit_code(:statement, code_snippet, :return) do
    code_snippet <>
      """
      ret
      """
  end

  def emit_code(:unary_negation, code_snippet, :negation) do
    code_snippet <>
      """
      neg    %eax
      """
  end

  def emit_code(:unary_logicalneg, code_snippet, :logicalNeg) do
    code_snippet <>
      """
      cmpl   $0, %eax
      movl   $0, %eax
      sete   %al
      """
  end

  def emit_code(:unary_complement, code_snippet, :bitWise) do
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

  def emit_code(:binary, code_snippet, :multiplication) do
    code_snippet <>
      """
      imul   %rbx, %rax
      """
  end

  def emit_code(:binary, code_snippet, :negation) do
    code_snippet <>
      """
      sub    %rax, %rbx
      mov    %rbx, %rax
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

  # ENTREGA 04
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

  # -------------------------------

  def emit_code(:constant, _code_snippet, valor) do
    """
    mov     $#{valor}, %rax
    """
  end
end
