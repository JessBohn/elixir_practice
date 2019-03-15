defmodule IslandsEngine.Island do
   alias IslandsEngine.{Coordinate, Island} # aliases the modules so you don't have to type the full IslandsEngine before everything

   @enforce_keys [:coordinates, :hit_coordinates] # comparable to require in Ruby/Rails, will throw an error if both keys aren't present
   defstruct [:coordinates, :hit_coordinates]

   #  defines the coordinate offsets for each valid island type
   defp offsets(:square), do: [{0,0}, {0,1}, {1,0}, {1,1}]
   defp offsets(:atoll), do: [{0,0}, {0,1}, {1,1}, {2,0}, {2,1}]
   defp offsets(:dot), do: [{0,0}]
   defp offsets(:l_shape), do: [{0,0}, {1,0}, {2,0}, {2,1}]
   defp offsets(:s_shape), do: [{0,1}, {0,2}, {1,0}, {1,1}]
   # when the island type entered doesn't match any of the above, return the error of invalid_island_type
   defp offsets(_), do: {:error, :invalid_island_type}

   # creates a new "Island"
   # with/1 special form - preferred way to handle multiple conditions when creating a valid item
      # keeps all validations in one place, and gives a separate area for handling errors
   def new(type, %Coordinate{} = upper_left) do
      with [_|_] = offsets <- offsets(type), %MapSet{} = coordinates <- add_coordinates(offsets, upper_left)
      do
         {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
      else
         error -> error
      end
   end

   # need to validate each coordinate as we build an island struct and stop if one is invalid
   # reduce_while takes an enumerable, starting value for an accumulator, and a funtion to apply to each enumerated value
   # takes the lists of offsets, a new MapSet to start the island, and an offset function that will run the add_coordinate function
   defp add_coordinates(offsets, upper_left) do
      Enum.reduce_while(offsets, MapSet.new(), fn offset, acc -> add_coordinate(acc, upper_left, offset) end)
   end

   # This function is to validate the coordinates for a new island structure
   # takes the new coordinate starting point, creates a new Coordinate instance, and the different offset values
   # When the values are put into the Coordinate module they will be validated using the params enforced in the module definition
   defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
      case Coordinate.new(row + row_offset, col + col_offset) do
         {:ok, coordinate} ->
            {:cont, MapSet.put(coordinates, coordinate)} # reduce_while must receive a tuple of {:cont, some_value} or {:halt, some_value}
         {:error, :invalid_coordinate} ->
            {:halt, {:error, :invalid_coordinate}} # returning {:halt, _} will stop the reduce_while when there is an invalid_coordinate
      end
   end
end
