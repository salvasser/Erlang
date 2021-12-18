-module(user_id).
-export([read/0, receive_server/0, transmit/1]).
-record(person, {name="", phone, age, id}).

%	this function reads user data from a file and writes it to record
read() ->
	{ok, Data} = file:read_file('users.dat'),
	List_data = string:tokens(binary_to_list(Data), "\r\n\,\ "),
	read(List_data, []).
	
		read([], Acc) -> lists:reverse(Acc);
		read([H_name, H_phone, H_age, H_id|T_data], Acc) -> read(T_data, [#person{name = H_name, phone = list_to_integer(H_phone), age = list_to_integer(H_age), id = list_to_integer(H_id)} | Acc]).
	
%	this function finds the user by id
find_user(Id) ->
	Data = read(),
	find_user(Data, Id).
		
		find_user([], _Id) -> error;
		find_user([H|T], Id) -> compare(T, Id, H#person.id, H).
		
		compare(_T, Id, Id, H) -> H;
		compare(T, Id, _, _H) -> find_user(T, Id).

%	this function receives a message and sends user data	
receive_server() ->
	
	receive
		{Pid, Msg} when is_integer(Msg) ->
			Data_user = find_user(Msg),
			Pid ! Data_user;
			%receive_server();	this not work
		{Pid, _} -> Pid ! error
	after 10000 -> timeout
	end.
	%receive_server(). this work
	
%		this function sends the user id and receives the server response
transmit(Id) ->
	Node_name = 'receive@aleksandr-VirtualBox',
	net_adm:ping(Node_name),
	{server, Node_name} ! {self(), Id},
	
	receive
		error -> 'There is no such id in the database';
		Msg -> io:format("Name: ~p~nPhone: ~p~nAge: ~p~n", [Msg#person.name, Msg#person.phone, Msg#person.age])
	after 10000 -> timeout
	end.
