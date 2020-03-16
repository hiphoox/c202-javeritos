defmodule Linker do
  def generate_binary(assembler, assembly_path) do
    assembly_path = String.replace_trailing(assembly_path, ".c", ".s")
    assembly_file_name = Path.basename(assembly_path)
    binary_file_name = Path.basename(assembly_path, ".s")
    output_dir_name = Path.dirname(assembly_path)
    assembly_path = output_dir_name <> "/" <> assembly_file_name
    File.write!(assembly_path, assembler)
    System.cmd("gcc", [binary_file_name <> ".c", "-o#{binary_file_name}"], cd: output_dir_name)
    IO.puts("Assembly code Generated : #{assembly_path}")
    IO.puts("Exectutable generated: #{output_dir_name}" <> "/" <> "#{binary_file_name}")
    # File.rm!(assembly_path)
  end

  def generate_new_binary(assembler, assembly_path, name) do
    assembly_path = String.replace_trailing(assembly_path, ".c", ".s")
    binary_file_name = Path.basename(assembly_path, ".s")
    output_dir_name = Path.dirname(assembly_path)
    assembly_path = output_dir_name <> "/" <> name <> ".s"

    File.write!(assembly_path, assembler)
    System.cmd("gcc", [binary_file_name <> ".c", "-o#{name}"], cd: output_dir_name)
    IO.puts("Assembly generated : #{assembly_path}")
    IO.puts("Executable generated : #{output_dir_name}" <> "/" <> "#{name}")

    # File.rm!(assembly_path)
  end
end
