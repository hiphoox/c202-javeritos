defmodule Parser do
  # ------------------PARSER PROGRAM--------------------
  def parse_program(tokenList) do

    test = next(tokenList) #Get the next KeyWord
    tokenListF = List.delete_at(tokenList, 0) #Deleting the head
    function = parse_function(test, tokenListF) #Make matching of C function strcture

    case function do
      {{:error, error_message}, tokenListF} -> #There was an error in parse_fuction
        {{:error, error_message}, tokenListF}
        {:error, error_message}

      {function_node, tokenListF} -> #There is a function_node
        if tokenListF == [] do #Verifying there is no more elements in the tuple
          %AST{node_name: :program, left_node: function_node} #Add the root to the AST
        else
          {:error, "Error: there are more elements after function end"}
        end
    end
  end

  # -------------Function to get the next keyword ----------

  @spec next(nonempty_maybe_improper_list) :: any
  def next(tokenListF) do
    first = Tuple.to_list(hd(tokenListF)) #Getting the next element
    test = List.first(first) #Getting the keyword

    if test == :ident || test == :type do  #Verifying if is a identificator or a data type
      if test == :num do
        List.last(first)
      else
        first = Tuple.to_list(hd(tokenListF)) #Getting the next element (Really the same item got at line 26)
        List.last(List.last(first)) #Getting the value (it cuould be "int" or "main")
      end
    else
      first = Tuple.to_list(hd(tokenListF))  #Same that as Line 26
      List.first(first) #Returning the keyword
    end
  end

  # -------------Get the number line----------

  def line(tokenListF) do
    first = Tuple.to_list(hd(tokenListF)) #Getting the relevant item

    cola = tl(first) #getting the field

    List.first(cola) #getting the value
  end

  # ------------------PARSER FUNCTION---------------------
  #Try to make matching with a C function strcuture
  def parse_function(nextToken, tokenListF) do
    if nextToken == :intKeyWord do #Matching with a intKeyWord
      nextToken = next(tokenListF)

      if nextToken == :mainKeyWord do #Matching with a mainKeyWord
        tokenListF = List.delete_at(tokenListF, 0)
        nextToken = next(tokenListF)

        if nextToken == :lParen do #Matching with a open parentesis
          tokenListF = List.delete_at(tokenListF, 0)
          nextToken = next(tokenListF)

          if nextToken == :rParen do #Matching with a close parentesis
            tokenListF = List.delete_at(tokenListF, 0)
            nextToken = next(tokenListF)

            if nextToken == :lBrace do #Matching with a open Brace
              tokenListF = List.delete_at(tokenListF, 0)
              nextToken = next(tokenListF)
              statement = parse_statement(nextToken, tokenListF)

              case statement do
                {{:error, error_message}, tokenListF} -> #Throws the error to the level up
                  {{:error, error_message}, tokenListF}

                {statement, tokenListF} ->
                  tokenListF = List.delete_at(tokenListF, 0)
                  nextToken = next(tokenListF)

                  if nextToken == :rBrace do #Matching with a close brace
                    tokenListF = List.delete_at(tokenListF, 0)
                    {%AST{node_name: :function, value: :main, left_node: statement}, tokenListF}
                  else
                    line = line(tokenListF)
                    {{:error, "*********ERROR AT #{line}: close brace missed "}, tokenListF}
                  end
              end
            else
              line = line(tokenListF)
              {{:error, "*********ERROR AT #{line}: open brace missed "}, tokenListF}
            end
          else
            line = line(tokenListF)
            {{:error, "*********ERROR AT #{line}: close parentesis missed "}, tokenListF}
          end
        else
          line = line(tokenListF)
          {{:error, "*********ERROR AT #{line}: open parentesis missed "}, tokenListF}
        end
      else
        line = line(tokenListF)
        {{:error, "*********ERROR AT #{line}: main function missed "}, tokenListF}
      end
    else
      line = line(tokenListF)
      {{:error, "*********ERROR AT #{line}: return type value missed "}, tokenListF}
    end
  end

  # ----------------PARSER STATEMENT--------------------
   #Try to make matching with a C statement structure
  def parse_statement(nextToken, tokenListF) do
    if nextToken == :returnKeyWord do
      tokenListF = List.delete_at(tokenListF, 0)
      expression= parse_expression(tokenListF)
      case expression do
        {{:error, error_message}, tokenListF} ->
          {{:error, error_message}, tokenListF}

        {expression, tokenListF} ->
          nextToken = next(tokenListF)

          if nextToken == :semicolon do #Matching with a ';'
            {%AST{node_name: :return, value: :return, left_node: expression}, tokenListF}
          else
            line = line(tokenListF)
            {{:error, "*********ERROR AT #{line}: semicolon missed after constant to finish return statement "},
             tokenListF}
          end
      end
    else
      line = line(tokenListF)
      {{:error, "*********ERROR AT #{line}: return keyword missed"}, tokenListF}
    end
  end

  # ----------------PARSER EXPRESSION--------------------
   #Try to make matching with a C expression structure
   #Only verify a constant expression
  def parse_expression(tokenListF) do
    nextToken = next(tokenListF)
    first = Tuple.to_list(hd(tokenListF))
    test = List.last(first)



    case {nextToken, test} do
      {:num, numero} ->
        tokenListF = List.delete_at(tokenListF, 0)
        {%AST{node_name: :constant, value: numero}, tokenListF}


      {:operator, _} ->
        parse_unary(tokenListF)
      _ ->
        line = line(tokenListF)
        {{:error, "*********ERROR AT #{line}: expect an int value"}, tokenListF}
    end


  end

  def parse_unary(tokenListF) do
    nextToken = next(tokenListF)
    first= Tuple.to_list(hd(tokenListF))
    test= List.last(first)

    case {nextToken, test} do

      {:operator, [:negation]} ->
        tokenListF= List.delete_at(tokenListF, 0)
        {tree, last} = parse_expression(tokenListF)

        case {tree, last} do
          {{:error, error_message}, tokenListF} ->
            {{:error, error_message}, tokenListF}

          _ -> {%AST{node_name: :unary, value: :negation, left_node: tree}, last}
        end

      {:operator, [:logicalNeg]} ->
         tokenListF = List.delete_at(tokenListF, 0)
         {tree, last}= parse_expression(tokenListF)
        case {tree, last} do
          {{:error, error_message}, tokenListF} ->
             {{:error, error_message}, tokenListF}
          _ -> {%AST{node_name: :unary, value: :logicalNeg, left_node: tree}, last}
        end

      {:operator, [:bitWise]} ->
        tokenListF= List.delete_at(tokenListF, 0)
        {tree, last}= parse_expression(tokenListF)

        case {tree, last} do
          {{:error, error_message}, tokenListF} ->
            {{:error, error_message}, tokenListF}
          _ -> {%AST{node_name: :unary, value: :bitWise, left_node: tree}, last}
        end
      _ ->
        line= line(tokenListF)
        {{:error, "*********ERROR AT #{line}: expect an unary expression"}, tokenListF}
    end
  end
end
