defmodule Lexer do

  def lexer(lexicon, columnNumber) do
    # Token list ready to be mapped and compared to the main.c token to the keywords list
    tokens = [
      {:type, :intKeyWord},
      {:ident, :returnKeyWord},
      {:ident, :mainKeyWord},
      {:lBrace},
      {:rBrace},
      {:lParen},
      {:rParen},
      {:semicolon},
      {:operator, :negation},
      {:operator, :logicalNeg},
      {:operator, :bitWise},
      {:operator, :addition},
      {:operator, :division},
      {:operator, :multiplication},
      {:operator, :logicalAnd},
      {:operator, :orlog},
      {:operator, :EqualTo},
      {:operator, :NotEqual},
      {:operator, :LessThan},
      {:operator, :LessOrEqual},
      {:operator, :Greather},
      {:operator, :GreatherOrEqual}
    ]
    mappedKeyW = fn a -> {tokenToStr(a), a} end
    keywords=Enum.map(tokens,mappedKeyW)
    spaces = ~r(^[ \h]+) #All spaces independently of the number of consecutive spaces
    newLine = ~r(^[\r\n]\n*) #\n independently of the number of consecutive newlines
    alphabet = ~r{(^[a-zA-Z]\w*)|(\|\|)} #All characters
    numbers = ~r(^[0-9]+) #All numbers independently of the number of consecutive integers


      #:check possible OVERFLOW? Should Lexer should check for the maximum amount of consecutive integers?  or only check if the number "belongs" to the grammar?



    cond do
      lexicon == "" ->
        []

      Regex.match?(spaces, lexicon) -> #Boolean
        lexer(Regex.replace(spaces, lexicon, "", global: false), columnNumber) #Find space, replace it with absolutely nothing

      Regex.match?(newLine, lexicon) ->
        # This is a Return
        lexer(Regex.replace(newLine, lexicon, "", global: false), columnNumber + 1) #Column number increases (check)

      Regex.match?(numbers, lexicon) ->
        num = String.to_integer(List.first(Regex.run(numbers, lexicon))) #convert it to an integer (IMPORTANT)
        [
          {:num, columnNumber, num}
          | lexer(Regex.replace(numbers, lexicon, "", global: false), columnNumber)
        ]

      true ->
        {result, tokenStr} = checkKW(lexicon, keywords)

        cond do
          # show the keyword in case it exists
          result ->
            case tokenStr do
              {str, {a, b}} ->
                [{a, columnNumber, [b]} | lexer(String.replace_leading(lexicon, str, ""), columnNumber)] #pair list

              {str, {a}} ->
                [
                  {a, columnNumber, []}
                  | lexer(String.replace_leading(lexicon, str, ""), columnNumber)
                ]
            end

          # If there's no match

          Regex.match?(alphabet, lexicon) ->
            identify = List.first(Regex.run(alphabet, lexicon, [{:capture, :first}])) #Run the regex vs the lexicon and return the matches
            token = {:string, columnNumber, [identify]} #Pair the column and the matches
            [token | lexer(Regex.replace(alphabet, lexicon, "", global: false), columnNumber)] #take the token

          true -> #otherwise, if theres an unrecognaziable character:
            raise "*********ERROR AT  " <>"#{lexicon}" <> "ON COLUMN LINE  "  <> "#{columnNumber}"
        end
    end
  end
  def lexing(lexicon) do
    # Each time we find a newLine we keep track to tell you if xenon finds an non belonging character
    columnNumber = 1
    # on which column the character was found, independently of the structure, for example
    # int main (){  LINE 1 \n Column+1
    # .            LINE 2\n Column+2
    # .            .
    # .            . (n) times Column+n
    # return constant; \line N ColumnNumber=n
    # }
    lexer(lexicon, columnNumber)
  end

  def tokenToStr(token) do #Correlating the token to its String representation
    case token do
      {:number, number} ->
        to_string(number)      # is it a number? Convert it to show it
      {:string, str} ->
        str             #no need to convert return the string
      {:type, :intKeyWord} ->
        "int " # is it an int
      {:ident, :returnKeyWord} ->
         "return " #  return
      {:ident, :mainKeyWord} ->
        "main" #  main
      #Unary type
      {:operator, :negation} ->
        "-"
      {:operator, :logicalNeg} ->
        "!"
      {:operator, :bitWise} ->
        "~"
      #Binary types
      {:operator, :addition} ->
        "+"
      {:operator, :division} ->
         "/"
      {:operator, :multiplication} ->
         "*"

      #Binary types part II
    {:operator, :NotEqual} ->
      "!="
    {:operator, :logicalAnd} ->
      "&&"
    {:operator, :orlog} ->
      "||"
    {:operator, :EqualTo} ->
       "=="
    {:operator, :LessThan} ->
       "< "#Watch the spaces
    {:operator, :LessOrEqual} ->
       "<="
    {:operator, :Greather} ->
      "> "
    {:operator, :GreatherOrEqual} ->
      ">="

      #Program Syntax Type
      {:lBrace} ->
         "{"
      {:rBrace} ->
         "}"
      {:lParen} ->
         "("
      {:rParen} ->
         ")"
      {:semicolon} ->
        ";"
    end
  end

  def checkKW(input, keywords) do
    Enum.reduce_while(keywords, {}, fn {key, val}, _ -> #check until the collection ends
      if !String.starts_with?(input, key) do
        {:cont, {false, {}}}  #continue iterating
      else
        {:halt, {true, {key, val}}}   #end of collection
      end
    end)
  end
  @type tokenStr :: {String.t(), tuple}
  # a string token is defined by the string.t(), same as a binary type (important for regex! module) with encoding UTF 8, this is useful to compare to the regular expression list
  # and know which element does not belong to the grammar (more info en lexer function)
end
