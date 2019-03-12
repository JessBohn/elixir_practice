# CHAPTER 4

# sums all numbers from 0 up to parameterized numbers

defmodule Sum do
   def up_to(0), do: 0
   def up_to(n), do: n + up_to(n-1)
end
