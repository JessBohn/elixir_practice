# CHAPTER 5

defmodule Factorial do
   def of(0), do: 1
   def of(n) when n > 0 do
      # 1..10_000_000 - ranges only work up to 10 million as shown to the left
      Stream.iterate(1, &(&1 + 1)) - # will work to infinity
         |> Enum.take(n)
         |> Enum.reduce(&(&1* &2))
   end
end
