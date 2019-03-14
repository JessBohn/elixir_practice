# For a given list with  integers, return a new list removing the elements at odd positions.
# The input and output portions will be handled automatically.
# You need to write a function with the recommended method signature.
# JK, this module will be made to work specifically with a given list.
# None of that file reading stuff

defmodule FilterPosInList do
   IO.stream(:stdio, :line)
   |> Enum.map(&String.trim/1)
   |> Enum.map(&String.to_integer/1)
   |> Enum.drop_every(2)
   |> Enum.each(&IO.puts(&1))
end
