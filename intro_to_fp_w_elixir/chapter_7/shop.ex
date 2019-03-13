# USING WITH
   # with clause is similar to how case statement works
   # <- operator means the right side block will be executed first THEN matched to the left side block
   # instructions inside the with are executed in order
   # if an instruction doesn't have a match, Elixir will stop and return the unmatched value

defmodule Shop do
   def checkout() do
      with {quantity, _} <- ask_number("Quantity?"),
            {price, _} <- ask_number("Price?"),
         quantity * price
      else
         :error ->
            IO.puts("It's not a number")
      end
   end

   def calculate(:error, _), do: IO.puts("Quantity is not a number")
   def calculate(_, :error), do: IO.puts("Price is not a number")
   def calculate({quantity, _}, {price, _}), do: quantity * price

   def ask_number(message) do
      message <> "\n"
         |> IO.gets
         |> Integer.parse
   end
end
