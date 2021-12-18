-module(transmit).
-export([func/1]).
-record(person, {name="", phone, age, id}).


%		this function sends the user id and receives the server response
func(Id) ->
	Node_name = 'receive@aleksandr-VirtualBox',
	net_adm:ping(Node_name),
	{server, Node_name} ! {self(), Id},
	
	receive
		Msg when Msg == error -> 'There is no such id in the database';
		Msg -> io:format("Name: ~p~nPhone: ~p~nAge: ~p~n", [Msg#person.name, Msg#person.phone, Msg#person.age])
	after 10000 -> timeout
	end.
