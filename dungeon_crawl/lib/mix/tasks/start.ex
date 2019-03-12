# This module is turned into a Mix task by using the Mix.Task directive
# can be used by calling 'mix start'

defmodule Mix.Tasks.Start do
   use Mix.Task

   def run(_), do: DungeonCrawl.CLI.Main.start_game
end
