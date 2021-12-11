-module(test).
-export([server/1]).

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
	


user_handler(Msg)->
	S = string:tokens(binary_to_list(Msg), "\r\n\, "),
	case lists:member("/index1", S) of
		true -> "index1.html";
		false -> begin
				case lists:member("/index2", S) of
					true -> "index2.html";
					false -> begin
							case lists:member("/index3", S) of
								true -> "index3.html";
								false -> "start_page.html"
							end
						end
				end
			end
	end.

%	if (lists:member("/index1", S)) == true -> "index1.html"
%		(lists:member("/index1", S)) =:= false -> "start_page.html"
%	end.


read_file(Msg)-> 
	{ok, Data} = file:read_file(user_handler(Msg)),
	Data.
	%erlang:binary_to_list(Data).

	
%	Response = "HTTP/1.1 200 OK
%	Content-Type: text/html; charset=utf-8
%	Content-Lenght: " ++ erlang:integer_to_list(string:leng(HTMLFromFile)) ++ "
%	
%	" ++ HTMLFromFile,
