# CHAPTER 3

# Create a script that asks a user for their salary and returns their income tax and net wage
# must parse the user's input and return an error when the user inputs an invalid number

defmodule IncomeTax do
   def total(salary) when salary <= 2000, do: 0
   def total(salary) when salary <= 3000, do: salary * 0.05
   def total(salary) when salary <= 6000, do: salary * 0.10
   def total(salary), do: salary * 0.15
end

input = IO.gets "Your salary:\n"

case Float.parse(input) do
   :error -> IO.puts "Invalid salary: #{input}"
   {salary, _} ->
      tax = IncomeTax.total(salary)
      IO.puts "Net wage: #{salary - tax} - Income tax: #{tax}"
end
