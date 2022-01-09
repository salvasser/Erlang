-module(server).
-export([server/0]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%server part
client_next(ClientSocket) ->
	{ok, Msg} = gen_tcp:recv(ClientSocket, 0),
	io:format("~p~n", [Msg]),
	All_id = id_list(),
	HTML = web_data(handler(Msg), Msg, All_id),
	Response = "HTTP/1.1 200 OK\nContent-Type: text/html; charset=utf-8\nContent-Length: " ++ erlang:integer_to_list(string:length(HTML)) ++ "\n\n" ++ HTML,

	gen_tcp:send(ClientSocket, Response),
	gen_tcp:close(ClientSocket).

client(ServerSocket) ->
	{ok, ClientSocket} = gen_tcp:accept(ServerSocket),
	erlang:spawn(fun() -> client_next(ClientSocket) end),
	client(ServerSocket).

server() ->
	sql_start(),
	{ok, ListenSocket} = gen_tcp:listen(8070, [binary, {active, false},{reuseaddr, true}]),
	client(ListenSocket).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%this function processes the user's request	
handler(Msg) ->
	List_text = ["get-users", "get-user", "delete-user", "add-user"],
	[_Unused, Request, _Id | _Tail] = splitting(Msg),
	handler(Request, List_text).
	
	handler(_Request, []) -> "start-page";
	handler(Request, [H_text|T_text]) -> 
		case Request == H_text of
			true -> H_text;
			false -> handler(Request, T_text)
		end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%function call according to the processed user request	
web_data("start-page", _Msg, _All_id) -> 
	{ok, Data} = file:read_file("start_page.html"),
	Data;
web_data("get-users", Msg, _All_id) -> 
	[Term, Age] = find_number(Msg),
	%io:format("~p~n", [Var]),
	case (Term == "younger") or (Term == "older") of
		true -> case Term == "younger" of
				true -> "<h1>User data</h1><br>" ++ "<table>" ++ output(younger_than(Age)) ++ "</table>";
				false -> "<h1>User data</h1><br>" ++ "<table>" ++ output(older_than(Age)) ++ "</table>"
			end;
		false -> "<h1>User data</h1><br>" ++ "<table>" ++ output(all_users()) ++ "</table>"
	end;
	
	%"<h1>User data</h1><br>" ++ "<table>" ++ output(all_users()) ++ "</table>";
web_data("get-user", Msg, All_id) -> 
	[_Term, ID] = find_number(Msg),
	Number = checkup_id(All_id, ID),
	case Number == missing of
		true -> "<h3>There is no user with this ID, check the data<h3>";
		false -> "<h1>User " ++ integer_to_list(Number) ++ " data</h1><br>" ++ "<table>" ++ output(one_user_id(Number)) ++ "</table>"
	end;
web_data("delete-user", Msg, All_id) -> 
	[_Term, ID] = find_number(Msg),
	Number = checkup_id(All_id, ID),
	case Number == missing of
		true -> "<h3>There is no user with this ID, check the data<h3>";
		false -> delete_user(Number),
			"<h1>Removing a user</h1><br><p>user " ++ integer_to_list(Number) ++ " deleted</p>"
	end;
web_data("add-user", _Msg, All_id) -> 
	add_user(All_id).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%working with a database
sql_start() ->
	{ok, Pid} = mysql:start_link([{host, "localhost"}, {user, "aleksandr"}, {password, "password"}, {database, "erlang"}]),
	true = erlang:register(db, Pid).

id_list() ->
	{ok, _Key, All_id} = mysql:query(db, <<"SELECT id FROM users2">>),
	make_list(All_id, []).
	
			make_list([], Acc) -> Acc;
			make_list([H_id | T_id], Acc) -> make_list(T_id, [binary_to_list(list_to_binary(H_id)) | Acc]).

all_users() ->
	{ok, _Key, Data} = mysql:query(db, <<"SELECT * FROM users2">>),
	Data.

one_user_id(Number_id) ->
	{ok, _Key, [User_data]} = mysql:query(db, <<"SELECT * FROM users2 WHERE id = ?">>, [Number_id]),
	[User_data].

delete_user(Number_id) ->
	mysql:query(db, <<"DELETE FROM users2 WHERE id = ?">>, [Number_id]).
	
add_user(All_id) ->
	{ok, [ID]} = io:fread("Enter ID: ", "~s"),
	{ok, [Name]} = io:fread("Enter Name: ", "~s"),
	{ok, [Phone]} = io:fread("Enter Phone: ", "~s"),
	{ok, [Age]} = io:fread("Enter Age: ", "~d"),
	Number = checkup_id(All_id, ID),
	case Number == missing of
		true -> mysql:query(db, <<"INSERT INTO users2 (id, fio, phone, age) VALUES (?,?,?,?)">>, [ID, Name, Phone, Age]),
			"<h3>User added</h3>";
		false -> "<h3>Error adding. User with this ID already exists</h3>"
	end.
	
younger_than(Age) ->
	{ok, _Key, User_data} = mysql:query(db, <<"SELECT * FROM users2 WHERE age < ?">>, [Age]),
	User_data.
	
older_than(Age) ->
	{ok, _Key, User_data} = mysql:query(db, <<"SELECT * FROM users2 WHERE age > ?">>, [Age]),
	User_data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%this function gets a number from a request
find_number(Msg) ->
	[_Unused, _Request, Number_text | _Tail] = splitting(Msg),
	List = string:lexemes(Number_text, "-"),
	case length(List) == 2 of
		true -> List;
		false -> [error, ""]
	end.
%%checking for the existence of an ID
checkup_id(All_id, Id) ->
	case lists:member(Id, All_id) of
		true -> list_to_integer(Id);
		false -> missing
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%%splits the message into parts
%%is called twice, therefore moved to a separate function
splitting(Msg) ->
	string:tokens(binary_to_list(Msg), "\r\n\,\/ ").
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output(Data) ->
	write_data(Data, []).
	
	write_data([], Acc) -> ["<tr>", "<td>", "<h4>", "id", "</h4>", "</td>", "<td>", "<h4>", "name", "</h4>", "</td>", "<td>", "<h4>", "phone", "</h4>" "</td>", "<td>", "<h4>", "age", "</h4>", "</td>", "</tr>"] ++ lists:reverse(Acc);
	write_data([[H_id, H_name, H_phone, H_age]|T_data], Acc) -> 
		write_data(T_data, ["</tr>", "</td>", integer_to_list(H_age), "<td>", "</td>", H_phone, "<td>", "</td>", H_name, "<td>", "</td>", H_id, "<td>", "<tr>" | Acc]).	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	





