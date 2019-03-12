defmodule EvenOrOdd do
   require Integer

   def check(number) when Integer.is_even(number), do: "even"
   def check(number) when Integer.is_odd(number), do: "odd"
end
