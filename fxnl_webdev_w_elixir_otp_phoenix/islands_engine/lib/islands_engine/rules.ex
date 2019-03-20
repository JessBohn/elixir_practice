defmodule IslandsEngine.Rules do
   alias __MODULE__

   defstruct state: :initialized, player1: :islands_not_set, player2: :islands_not_set
   def new(), do: %Rules{}

   # a new game is in the initialized state
   # check on adding a player and then transition to players_set
   def check(%Rules{state: :initialized} = rules, :add_player), do: {:ok, %Rules{rules | state: :players_set}}
   # each player should be able to move an island while the state is still players_set
   def check(%Rules{state: :players_set} = rules, {:position_islands, player}) do
      case Map.fetch!(rules, player) do
         :islands_set -> :error
         :islands_not_set -> {:ok, rules}
      end
   end
   # when one player sets their islands, they should no longer be able to move them, but the other player should
      # when both players have set their islands, state transitions to player1's turn
   def check(%Rules{state: :players_set} = rules, {:set_islands, player}) do
      rules = Map.put(rules, player, :islands_set)
      case both_players_islands_set?(rules) do
         true -> {:ok, %Rules{rules | state: :player1_turn}}
         false -> {:ok, rules}
      end
   end
   # during player1's turn, only they should be able to guess or do anything
   def check(%Rules{state: :player1_turn} = rules, {:guess_coordinate, :player1}), do: {:ok, %Rules{rules | state: :player2_turn}}
   # check to see if their turn has won the game or not
      # if they win, the game is over
      # else, transitions to player2's turn
   def check(%Rules{state: :player1_turn} = rules, {:win_check, win_or_not}) do
      case win_or_not do
         :no_win -> {:ok, rules}
         :win -> {:ok, %Rules{rules | state: :game_over}}
      end
   end
   # check to see if their turn has won the game or not
      # if they win, the game is over
      # else, transitions to player1's turn
   def check(%Rules{state: :player2_turn} = rules, {:guess_coordinate, :player2}), do: {:ok, %Rules{rules | state: :player1_turn}}
   def check(%Rules{state: :player2_turn} = rules, {:win_check, win_or_not}) do
      case win_or_not do
         :no_win -> {:ok, rules}
         :win -> {:ok, %Rules{rules | state: :game_over}}
      end
   end
   def check(_state, _action), do: :error # this part of the catchall clause must be defined after all the others, otherwise it would always match to be an error
   # function to return whether or not both players have set their islands
   defp both_players_islands_set?(rules) do
      rules.player1 == :islands_set && rules.player2 == :islands_set
   end
end
