# CHAPTER 5

defmodule HigherOrderFunctions do
   def compose(f, g) do
      fn arg -> f.(g.(arg)) end
   end
end
