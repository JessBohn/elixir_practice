# CHAPTER 3
#     INCOME TAX EXERCISE

#  This program should do the following
#  calculates the respective income tax for a given salary
#  salary <= 2,000, pays 0; <= 3,000, pay 5%; <= 6,000, 10%; > 6000, pays 15%

defmodule IncomeTax do
   def total(salary) when salary <= 2000, do: 0
   def total(salary) when salary <= 3000, do: salary * 0.05
   def total(salary) when salary <= 6000, do: salary * 0.10
   def total(salary), do: salary * 0.15
end
