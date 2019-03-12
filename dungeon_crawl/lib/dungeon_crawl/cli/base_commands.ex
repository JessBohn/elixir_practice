defmodule DungeonCrawl.CLI.BaseCommands do
   alias Mix.Shell.IO, as: Shell

   @invalid_option {:error, "Invalid option"}

   def display_options(options) do
      options
      |> Enum.with_index(1)
      |> Enum.each(fn {option, index} ->
         Shell.info("#{index} - #{option}")
      end)
      options
   end

   def generate_question(options) do
      options = Enum.join(1..Enum.count(options),",")
      "Which one? [#{options}]\n"
   end

   def parse_answer(answer) do
      case Integer.parse(answer) do
         :error ->
            throw @invalid_option
         {option, _} ->
            option -1
      end
   end

   def find_option_by_index(index, options) do
      Enum.at(options, index) || throw @invalid_option
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

   def ask_for_option(options) do
      # 'try do' can be omitted, but it makes the happy path harder to see
      try do
         options
         |> display_options
         |> generate_question
         |> Shell.prompt
         |> parse_answer!
         |> find_option_by_index(options)
      catch # if the sequence above fails, the program will continue with below
         {:error, message} ->
            display_error(message)
            ask_for_option(options)
      end
   end

   def display_error(e) do
      Shell.cmd("clear")
      Shell.error(message)
      Shell.prompt("Press Enter to continue.")
      Shell.cmd("clear")
   end
end
