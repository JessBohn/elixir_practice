# CHAPTER 5 - HIGHER-ORDER functions
# This file contains an introduction to higher-order functions using lists
# Higher-order functions allow for handling & manipulating lists without showing all the work and just getting straight to the point

defmodule MyList do
   #  iterates through and displays each item from the list with the given parameter
   def each([], _function), do: nil
   def each([head | tail], function) do
      function.(head)
      each(tail, function)
   end

   # iterates through a list, applies the given function, and maps the new values to a new list
      # increase_price = fn item -> update_in(item.price, &(&1 * 1.1)) end
      # MyList.map(enchanted_items, increase_price)    ( where enchanted_items is a pre-defined list of items with a given price )
         # -> [
              # %{price: 165.0, title: "Edwin's Longsword"},
              # %{price: 66.0, title: "Healing Potion"},
              # %{price: 33.0, title: "Edwin's Rope"},
              # %{price: 110.00000000000001, title: "Dragon's Spear"} ]
   def map([], _function), do: []
   def map([head | tail], function) do
      [function.(head) | map(tail, function)]
   end

   # iterates through the given list, and applies the given function to each value, resulting in one value for the entire list. starting at the given value
      # reduce.([10, 5, 5, 10], 1, &*/2) -> 1 * 10 -> 10 * 5 -> 50 * 5 -> 250 * 10 -> 2500
      # the starting value is 1 and it multiples itself by each item in the list, one at a time, saving the new result as the starting value
   def reduce([], acc, _function), do: acc
   def reduce([head | tail], acc, function) do
      reduce(tail, function.(head, acc), function)
   end

   # filtering a list will create a new list with only the elements that pass the given criteria
   # if (true) pass to new list, else keep going
   # either way, the new list is build by making a recursive call on the tail of the given list
      # i.e. iex(6)> MyList.filter(enchanted_items, fn item -> item.price < 70 end)
               # [%{price: 60, title: "Healing Potion"}, %{price: 30, title: "Edwin's Rope"}]
   def filter([], _function), do: []
   def filter([head | tail], function) do
      if function.(head) do
         [head | filter(tail, function)]
      else
         filter(tail, function)
      end
   end
end
