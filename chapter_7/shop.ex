defmodule Shop do
   def checkout() do
      quantity = ask_number("Quantity?")
      price = ask_number("Price?")
      calculate(quantity, price)
   end

   def ask_number(message) do
      message <> "\n"
         |> IO.gets
         |> Integer.parse
   end
end
