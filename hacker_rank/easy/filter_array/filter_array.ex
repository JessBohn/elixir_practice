# Filter a given array of integers and output only those values that are less than a specified value .
# The output integers should be in the same sequence as they were in the input.
# You need to write a function with the recommended method signature for the languages mentioned below

defmodule Solution do
   def main(limit, data) do
      list = convert_list(data) # runs the defined function, receiving the already mapped lsit of integers
      for d <- list, d < limit, do: IO.puts d # for d less than list item, nothing; for item less than d, put d
   end

   def convert_list(data) do
      data
      |> String.trim # removes any trailing whitespace
      |> String.split # splits the integers up into separate items in a list
      |> Enum.map(&String.to_integer/1) # takes each string item in the list, converts it to an integer, maps to new list
   end
end

limit = IO.gets("") |> String.trim |> String.to_integer # gets the delimiter input, trims whitespace, converts to integer
data = IO.read(:stdio, :all) # reads the entire rest of the input to be the list
Solution.main(limit, data)
