defmodule Tasks do

###################################
	def output(n) do
		output(n, 1)
	end

	defp output(1, acc) do
		IO.puts("#{acc}")
	end
	defp output(n, acc) when n>1 do
		IO.puts("#{acc}")
		output(n-1, acc+1)
	end

###################################
	def out_AB(a, b) do
		output_AB(a, b)
	end

	defp output_AB(a, a) do
		IO.puts("#{a}")
	end
	defp output_AB(a, b) when b>a do
		IO.puts("#{a}")
		output_AB(a+1, b)
	end
	defp output_AB(a, b) when b<a do
		IO.puts("#{a}")
		output_AB(a-1, b)
	end

###################################
	def akkerman(m, n) do
		akk(m, n)
	end	

	defp akk(0, n) do
		n+1
	end
	defp akk(m, 0) when m>0 do
		akk(m-1, 1)
	end
	defp akk(m, n) when m>0 and n>0 do
		akk(m-1, akk(m, n-1))
	end

###################################
	def two_power(n) do
		power(n)
	end

	defp power(1.0) do
		IO.puts("YES")
	end
	defp power(1) do
		IO.puts("YES")
	end
	defp power(n) when n>=2 do
		power(n/2)
	end
	defp power(_) do
		IO.puts("NO")
	end

###################################
	def sum(n) do
		sum(n,0)
	end

	defp sum(0, acc) do
		acc
	end
	defp sum(n, acc) do
		sum(n-1, acc+n)
	end

###################################
	def fibonacci(number) do
		fib(number, 0)
	end

	defp fib(0, acc) do
		acc 
	end
	defp fib(1, acc) do
		acc+1
	end
	defp fib(number, acc) when number>1 do
		fib(number-1, acc) + fib(number-2, acc)
	end

###################################
	def factorial(number) do
		fac(number, 1)
	end

	defp fac(0, acc) do
		acc
	end
	defp fac(number, acc) when number>0 do
		fac(number-1, number*acc)
	end

end