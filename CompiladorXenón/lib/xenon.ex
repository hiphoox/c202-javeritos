defmodule XENON do
  def main(args) do
    # Compiler options
    case args do
      # For example [escript xenon -switch "namefile.c"]
      # help
      ["-h"] ->
        IO.puts("Available switches:\n
      -t [filename.c]  Show token list.
      -a [filename.c]  Show AST.
      -s [filename.c]  Show assembly.
      -c [filename.c]  Compile program (check the same folder for [filename].exe).
      -o [filename.c]  [[newFilename].exe]  Compile the program with a new name.")

      # Token list
      ["-t", path] ->
            IO.puts("Token List: \n\n\n\n")
            # print token list
            # Stop at  1
            IO.inspect(Lexer.lexing(File.read!(path)))
      # Print ast
      ["-a", path] ->
        IO.puts("Printing AST:\n\n\n\n")
        tokens = Lexer.lexing(File.read!(path))
        ast = Parser.parse_program(tokens)
        # stop at step 2
        IO.inspect(ast)

      # Show Ass.code
      ["-s", path] ->
        IO.puts("Assembly code\n\n\n\n")
        tokens = Lexer.lexing(File.read!(path))
        ast = Parser.parse_program(tokens)
        # stop at step 3
        assemblyCode = CodeGenerator.generate_code(ast)
        IO.puts(assemblyCode)

      # Full compile
      ["-c", path] ->
        IO.puts("Compiling the file: " <> path)
        tokens = Lexer.lexing(File.read!(path))
        ast = Parser.parse_program(tokens)
        assemblyCode = CodeGenerator.generate_code(ast)
        Linker.generate_binary(assemblyCode, path)

      # Full compile but with name change
      ["-o", path, newFilename] ->
        IO.puts(
          "Compiling the file:  " <>
            path <> " And renaming the executable to: " <> newFilename <> "\n\n\n\n"
        )

        tokens = Lexer.lexing(File.read!(path))
        ast = Parser.parse_program(tokens)
        assemblyCode = CodeGenerator.generate_code(ast)
        # do the full compiler route
        Linker.generate_new_binary(assemblyCode, path, newFilename)
      # but change the name (generate_binary (3))
      _ -> #The user input is wrong, show him some examples
        IO.puts("Please check your sintax
        Please ensure that:
        1-. file is on the SAME PATH as the xenon files
        2-. calling Xenon correctly for example:
               --->escript xenon -c [filename.c (BETWEEN DOUBLE QUOTES)]
        For your convenience, the list of switches are as follows: ")
        IO.puts("Available switches:\n
        -t [filename.c]  Show token list.
        -a [filename.c]  Show AST.
        -s [filename.c]  Show assembly.
        -c [filename.c]  Compile program (check the same folder for [filename].exe).
        -o [filename.c]  [[newFilename].exe]  Compile the program with a new name.")
    end
  end
end
