defmodule Shop do
   def checkout(price) do
      case ask_number("Quantity?") do
         :error -> IO.puts("It's not a number")
         {quantity, _} -> quantity * price
      end
   end

   def ask_number(message) do
      message <> "\n"
         |> IO.gets
         |> Integer.parse
   end
end
