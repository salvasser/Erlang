-module(homework1).
-export([get_data/0, test/0]).

% function for collecting information
get_data() ->
	{ok, [Name]} = io:fread("Enter your name: ", "~s"),
	{ok, [Email]} = io:fread("Enter your email: ", "~s"),
	io:fwrite("Your name is ~s~n", [Name]),
	io:fwrite("Your email is ~s~n", [Email]).

%
%
% function that demonstrates the computation error	
test() ->
	io:fwrite("two to the power of a thousand in erlang:~n ~w~n", [math:pow(2,1000)]),
	io:fwrite("correct number:~n 1.07150861e301~n").
	
