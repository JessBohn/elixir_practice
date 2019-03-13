# Chapter 3 - Control-Flow Structures
# the require directive is lexically scoped, meaning the below module cannot be compiled.
# If a require is nested, it will not apply to the scopes outside of its current scope

defmodule EvenOrOdd do
   def is_even(number) do
      require Integer
      Integer.is_even(number)
   end

   def is_odd(number), do: Integer.is_odd(number)
end
