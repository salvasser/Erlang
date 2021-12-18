-module(test).
-export([server/1, receive_server/0, transmit/1]).

client_next(ClientSocket) ->
	{ok, Msg} = gen_tcp:recv(ClientSocket, 0),
	io:format("~p~n", [Msg]),
	Response = read_file(Msg),

	gen_tcp:send(ClientSocket, Response),
	gen_tcp:close(ClientSocket).
	%client(ClientSocket).

client(ServerSocket) ->
	{ok, ClientSocket} = gen_tcp:accept(ServerSocket),
	erlang:spawn(fun()->client_next(ClientSocket) end),
	client(ServerSocket).

server(Port) ->
	{ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false},{reuseaddr, true}]),
	client(ListenSocket).
	

user_handler(Msg) ->

	List_text = ["/index1", "/index2", "/index3"],
	List_index = ["index1.html", "index2.html", "index3.html"],
	List_data = string:tokens(binary_to_list(Msg), "\r\n\, "),
	user_handler(List_data, List_index, List_text).
	
	user_handler(_List_data, _List_text, []) -> "start_page.html";
	user_handler(List_data, [H_index|T_index], [H_text|T_text]) -> 
		case lists:member(H_text, List_data) of
			true -> H_index;
			false -> user_handler(List_data, T_index, T_text)
		end.


read_file(Msg)-> 
	{ok, Data} = file:read_file(user_handler(Msg)),
	Data.
	%erlang:binary_to_list(Data).

receive_server() ->
	
	receive
		{_Pid, Port} when is_integer(Port) -> server(Port)
	after 10000 -> timeout
	end.
	
transmit(Port) ->
	Node_name = 'receive6@aleksandr-VirtualBox',
	net_adm:ping(Node_name),
	{server, Node_name} ! {self(), Port}.

	
%	Response = "HTTP/1.1 200 OK
%	Content-Type: text/html; charset=utf-8
%	Content-Lenght: " ++ erlang:integer_to_list(string:leng(HTMLFromFile)) ++ "
%	
%	" ++ HTMLFromFile,
