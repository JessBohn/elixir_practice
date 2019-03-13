# CHAPTER 4

# this navigator will infinitely go through directories until it finds something
#  that isn't a directory.

# Avoiding Infinite Loops
   # to avoid infinite loops, all symbolic links to be removed and the program
   # should check if something is a real directory and not symbolic
   # To do so:
      # def dir?(dir) do
      #    {:ok, %{type: type}} = File.lstat(dir)
      #    type == :directory
      # end
   # replace all instances of File.dir? with the above custom function and the program
   # will no longer be prone to infinite loops through symbolic links
   
defmodule Navigator do
   def navigate(dir) do
      expanded_dir = Path.expand(dir)
      go_through([expanded_dir])
   end

   defp go_through([]), do: nil
   defp go_through([content | rest]) do
      print_and_navigate(content, File.dir?(content))
      go_through(rest)
   end

   defp print_and_navigate(_dir, false), do: nil
   defp print_and_navigate(dir, true) do
      IO.puts dir
      children_dirs = File.ls!(dir)
      go_through(expand_dirs(children_dirs, dir))
   end

   defp expanded_dirs([], _relative_to), do: []
   defp expanded_dirs([dir | dirs], relative_to) do
      expanded_dir = Path.expand(dir, relative_to)
      [expanded_dir | expand_dirs(dirs, relative_to)]
   end
end
