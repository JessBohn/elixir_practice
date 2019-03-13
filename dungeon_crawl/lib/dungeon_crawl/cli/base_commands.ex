# ADVANTAGES OF USING MONAD METHOD
   # clear happy path of the function pipeline
   # the error handling has been put at a unique point
   # fxn always return a value, returning a consistent data structure that flags an error or a success
# DISADVANTAGES
   # Elixir doesn't have built-in support for monads, so you have to choose a monad library from community
   # monad libraries may look disconnected from the rest of the language (~>> not as clean as |>)

defmodule DungeonCrawl.CLI.BaseCommands do
   use Monad.Operators

   alias Mix.Shell.IO, as: Shell
   import Monad.Result, only: [success: 1, success?: 1, error: 1, return: 1]

   def display_options(options) do
      options
      |> Enum.with_index(1)
      |> Enum.each(fn {option, index} ->
         Shell.info("#{index} - #{option}")
      end)

      return(options)
   end

   def generate_question(options) do
      options = Enum.join(1..Enum.count(options),",")
      "Which one? [#{options}]\n"
   end

   # the integer parsing can result in an error
   # check it using case with pattern matching
   # when result is an error - use error/1 to return an error result with a message
   # when parsed result is a valid number - use success/1 to return a success result wrapping the number
   def parse_answer(answer) do
      case Integer.parse(answer) do
         :error -> error("Invalid option")
         {option, _} -> success(option - 1)
      end
   end

   # same logic as parse_answer above
   # when matching nil, return an error result
   # when matching a number, return a success result
   def find_option_by_index(index, options) do
      case Enum.at(options, index) do
         nil -> error("Invalid option")
         chosen_option -> success(chosen_option)
      end
   end

   def ask_for_index(options) do
      answer =
         options
         |> display_options
         |> generate_question
         |> Shell.prompt
         |> Integer.parse

      case answer do
         :error ->
            display_invalid_option()
            ask_for_index(options)
         {option, _} ->
            option - 1
      end
   end

   def display_invalid_option do
      Shell.cmd("clear")
      Shell.error("Invalid option.")
      Shell.prompt("Press Enter to try again.")
      Shell.cmd("clear")
   end

   # updated to reflect new Error Monad method

   def ask_for_option(options) do
      # inside result, instead of the pipeline operator (|>), the bind operator (~>>) must be used to sequence the functions
      result =
         return(options)
         # |> display_options - standard pipeline syntax for the line below
         ~>> (&display_options/1) # must follow syntax - (bind operator) ~>> (&function/arity)
         ~>> (&generate_question/1)
         ~>> (&Shell.prompt/1)
         ~>> (&parse_answer/1)
         ~>> (&(find_option_by_index(&1, options)))
      if success?(result) do
         result.value
      else
         display_error(result.error)
         ask_for_option(options)
      end
   end

   def display_error(message) do
      Shell.cmd("clear")
      Shell.error(message)
      Shell.prompt("Press Enter to continue.")
      Shell.cmd("clear")
   end
end
