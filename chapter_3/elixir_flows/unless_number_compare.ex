# CHAPTER 3
#     unless CONTROL FLOW
#        - works the same as the unless/else clause in Ruby
#        - the unless block is executed when the expression is nil or false

defmodule NumberCompareWithUnless do
   def greater(number, other_number) do
      unless number < other_number do
         number
      else
         other_number
      end
   end
end
