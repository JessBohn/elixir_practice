# CHAPTER 3
#     if CONTROL FLOW

defmodule NumberCompareWithIf do
   def greater(number, other_number) do
      if number >= other_number do
         number
      else
         other_number
      end
   end
end
