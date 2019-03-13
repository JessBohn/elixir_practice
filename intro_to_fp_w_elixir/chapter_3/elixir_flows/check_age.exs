# CHAPTER 3
#     COND: CONTROL WITH LOGICAL EXPRESSIONS

#  cond doesn't need pattern matching to solve a problem

# This script is to check a person's age and return their age group
# possible results = kid, teen, adult

{age, _} = Integer.parse IO.gets("Person's age:\n")

result = cond do
   age < 13 -> "kid"
   age <= 18 -> "teen"
   age > 18 -> "adult"
end

IO.puts "Result: #{result}"
