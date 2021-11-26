%% This module generated a list of numbers, squares them and finds the sum of squares
%% Three numbers are given as arguments
%% The first number of the list, last number of the list and the step with which the generation takes place

-module (list_number).
-export ([calc_numbers/3]).

calc_numbers(First, Last, Step) ->
	N = lists:seq(First,Last,Step),
	Numbers = [N2*N2 || N2 <- N],
	io:fwrite("generated list is: ~p~n", [N]),
	io:fwrite("square of numbers is: ~p~n", [Numbers]),
	sum(Numbers, 0).
	
		sum([], Acc) -> io:fwrite("sum of squares is: ~p~n", [Acc]);
		sum([H|T], Acc) -> sum(T, Acc+H).
	
		
			
	


