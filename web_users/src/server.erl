-module(server).
-export([server/0, clear_data/0]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%server part
client_next(ClientSocket) ->
	{ok, Msg} = gen_tcp:recv(ClientSocket, 0),
	io:format("~p~n", [Msg]),
	AllId = id_list(),
	HTML = web_data(handler(Msg), Msg, AllId),
	Response = "HTTP/1.1 200 OK\nContent-Type: text/html; charset=utf-8\nContent-Length: " ++ erlang:integer_to_list(string:length(HTML)) ++ "\n\n" ++ HTML,

	gen_tcp:send(ClientSocket, Response),
	gen_tcp:close(ClientSocket).

client(ServerSocket) ->
	{ok, ClientSocket} = gen_tcp:accept(ServerSocket),
	erlang:spawn(fun() -> client_next(ClientSocket) end),
	client(ServerSocket).

server() ->
	sql_start(),
	{ok, ListenSocket} = gen_tcp:listen(8071, [binary, {active, false},{reuseaddr, true}]), %%localhost:8070
	client(ListenSocket).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%this function processes the user's request	
handler(Msg) ->
	ListOfText = ["get-users", "get-user", "delete-user", "add-user"],
	[_, Request, _Id | _Tail] = splitting(Msg),	
	handler(Request, ListOfText).
	
	handler(_Request, []) -> "start-page";
	handler(Request, [HeadText | TailText]) -> 
		case Request == HeadText of
			true -> HeadText;
			false -> handler(Request, TailText)
		end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%function call according to the processed user request	
web_data("start-page", _Msg, _AllId) -> 
	%Query = "start-page",
	{ok, Data} = file:read_file("resources/start_page.html"),
	Data;
web_data("get-users", Msg, _AllId) -> 
	Query = "get-users",
	[Term, Age] = find_number(Msg, Query),
	if
		Term == "younger" -> "<h1>User data</h1><br>" ++ "<table>" ++ output(younger_than(Age)) ++ "</table>";
		Term == "older" -> "<h1>User data</h1><br>" ++ "<table>" ++ output(older_than(Age)) ++ "</table>";
		true -> "<h1>User data</h1><br>" ++ "<table>" ++ output(all_users()) ++ "</table>"
	end;
web_data("get-user", Msg, AllId) -> 
	Query = "get-user",
	[Term, ID] = find_number(Msg, Query),
	Number = checkup_id(AllId, ID),
	case (not(Number == missing)) and (Term == "id") of
		true -> "<h1>User " ++ integer_to_list(Number) ++ " data</h1><br>" ++ "<table>" ++ output(one_user_id(Number)) ++ "</table>";
		false -> "<h3>There is no user with this ID, check the data<h3>"
	end;
web_data("delete-user", Msg, AllId) -> 
	Query = "delete-user",
	[Term, ID] = find_number(Msg, Query),
	Number = checkup_id(AllId, ID),
	case (not(Number == missing)) and (Term == "id") of
		true -> delete_user(Number),
			"<h1>Removing a user</h1><br><p>user " ++ integer_to_list(Number) ++ " deleted</p>";
		false -> "<h3>There is no user with this ID, check the data<h3>"
	end;
web_data("add-user", _Msg, AllId) -> 
	add_user(AllId).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%working with a database
sql_start() ->
	{ok, Pid} = mysql:start_link([{host, "db"}, {user, "root"}, {password, "123456"}, {database, "erlang"}]),
	true = erlang:register(db, Pid),
	existing_users().

existing_users() ->
	mysql:query(db, <<"CREATE TABLE IF NOT EXISTS users (id VARCHAR(4), first_name VARCHAR(255), phone VARCHAR(4), age INT)">>),
	{ok, Data} = file:read_file("resources/users.dat"),
	ListOfData = string:tokens(binary_to_list(Data), "\r\n\,\ "),
	read(ListOfData).
	
		read([]) -> ok;
		read([HeadId, HeadName, HeadPhone, HeadAge | TailData]) -> 
			mysql:query(db, <<"INSERT INTO users (id, first_name, phone, age) VALUES (?,?,?,?)">>, [HeadId, HeadName, HeadPhone, list_to_integer(HeadAge)]),								
			read(TailData).
	
	
id_list() ->
	{ok, _Key, AllId} = mysql:query(db, <<"SELECT id FROM users">>),
	make_list(AllId, []).
	
			make_list([], Acc) -> Acc;
			make_list([HeadId | TailId], Acc) -> make_list(TailId, [binary_to_list(list_to_binary(HeadId)) | Acc]).

all_users() ->
	{ok, _Key, Data} = mysql:query(db, <<"SELECT * FROM users">>),
	Data.

one_user_id(NumberId) ->
	{ok, _Key, [UserData]} = mysql:query(db, <<"SELECT * FROM users WHERE id = ?">>, [NumberId]),
	[UserData].

delete_user(NumberId) ->
	mysql:query(db, <<"DELETE FROM users WHERE id = ?">>, [NumberId]).
	
add_user(AllId) ->
	{ok, [ID]} = io:fread("Enter ID: ", "~s"),
	{ok, [Name]} = io:fread("Enter Name: ", "~s"),
	{ok, [Phone]} = io:fread("Enter Phone: ", "~s"),
	{ok, [Age]} = io:fread("Enter Age: ", "~d"),
	Number = checkup_id(AllId, ID),
	case Number == missing of
		true -> mysql:query(db, <<"INSERT INTO users (id, name, phone, age) VALUES (?,?,?,?)">>, [ID, Name, Phone, Age]),
			"<h3>User added</h3>";
		false -> "<h3>Error adding. User with this ID already exists</h3>"
	end.
	
younger_than(Age) ->
	{ok, _Key, UserData} = mysql:query(db, <<"SELECT * FROM users WHERE age < ?">>, [Age]),
	UserData.
	
older_than(Age) ->
	{ok, _Key, UserData} = mysql:query(db, <<"SELECT * FROM users WHERE age > ?">>, [Age]),
	UserData.
	
clear_data() ->
	sql_start(),
	mysql:query(db, <<"DROP TABLE users">>).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%this function gets a number from a request
find_number(Msg, Query) ->
	ListOfText = splitting(Msg),
	find_number(ListOfText, Query, []).
	
		find_number([Head1, Head2 | Tail], Query, Acc) -> if 
			Head1 /= Query -> find_number ([Head2 | Tail], Query, Acc);
			Head1 == Query -> 
				List = string:lexemes(Head2, "-"),
				case length(List) == 2 of	%checking the request in the form !"Term-Number"!
					true -> List;
					false -> [error, ""]
				end
		end.
%%checking for the existence of an ID
checkup_id(AllId, Id) ->
	case lists:member(Id, AllId) of
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
	write_data([[HeadId, HeadName, HeadPhone, HeadAge] | TailData], Acc) -> 
		write_data(TailData, ["</tr>", "</td>", integer_to_list(HeadAge), "<td>", "</td>", HeadPhone, "<td>", "</td>", HeadName, "<td>", "</td>", HeadId, "<td>", "<tr>" | Acc]).	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	



			





