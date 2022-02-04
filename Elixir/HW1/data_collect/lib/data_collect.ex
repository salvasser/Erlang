defmodule Collect do
	
	def main() do
		name = IO.gets("Enter your name: ") |> String.trim
		email = IO.gets("Enter your email: ") |> String.trim
		IO.puts("Your name: #{name}\nYour email: #{email}")
	end
	
end

