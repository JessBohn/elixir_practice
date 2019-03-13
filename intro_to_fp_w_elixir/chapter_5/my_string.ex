# CHAPTER 5

defmodule MyString do
   # The Proper Elixir way
   #  This shows the exact order in which the functions are executed
   #  The string is split, first letter upcased, then joined backed together with a space in between
   def capitalize_words(title) do
      title
      |> String.split
      |> capitalize_all
      |> join_with_whitespace
   end

   def capitalize_all(words) do
      Enum.map(words, &String.capitalize/1)
   end

   def join_with_whitespace(words) do
      Enum.join(words, " ")
   end

   # Original, inefficient way to write this function
   # def capitalize_words(title) do
   #    words = String.split(title)
   #    capitalized_words = Enum.map(words, &String.capitalize/1)
   #    Enum.join(capitalized_words, " ")
   # end

   # To do the same without using variables, it would be written as below
   # The readability of this is very poor and it should not be done this way
   # def capitalize_words(title) do
   #    Enum.join(
   #       Enum.map(
   #          String.split(title),
   #          &String.capitalize/1
   #       ), " "
   #    )
   # end


end
