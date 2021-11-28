-module(persons).
-export([database/0, age/0, average_age/0, phone/0, find_user/1]).
-record(person, {name="", phone, age}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%		User data
database() ->
	P1=#person{name = "Jonh", phone = 1115, age = 25},
	P2=#person{name = "Kevin", phone = 1785, age = 18},
	P3=#person{name = "Nora", phone = 4695, age = 36},
	P4=#person{name = "David", phone = 3964, age = 40},
	P5=#person{name = "Fiona", phone = 9358, age = 15},
	P6=#person{name = "Andrew", phone = 2574, age = 60},
	P7=#person{name = "Liza", phone = 7563, age = 34},
	P8=#person{name = "Stanly", phone = 2745, age = 51},
	P9=#person{name = "Sara", phone = 4833, age = 12},
	P10=#person{name = "Dash", phone = 7866, age = 22},
	
	[P1, P2, P3, P4, P5, P6, P7, P8, P9, P10].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%		This function returns a list of user ages	
age() ->
	Data = database(),
			
	age(Data, []).
		
		age([], Age) -> Age;
		age([H|T], Age) -> age(T, [Age | H#person.age]). 

%		This function returns a list of user phones. Not used		
phone() ->
	Data = database(),
	
	phone(Data, []).
	
		phone([], Phone) -> Phone;
		phone([H|T], Phone) -> phone(T, [Phone | H#person.phone]).

%		This function returns the average age of users
average_age() ->
	Age = age(),

	average_age(Age, 0, 0).
			
		average_age([], Acc, Len) -> io:fwrite("Average age of people in the database: ~p~n", [Acc/Len]);
		average_age([H|T], Acc, Len) -> average_age(H, Acc+T, Len+1).

%		This function allows you to find user data by phone number
find_user(Phone_number) ->
	Data = database(),
	
	find_user(Data, Phone_number).
	
		find_user([], _) -> io:fwrite("There is no such number in the database~n");
		find_user([H|T], Phone_number) -> compare(T, Phone_number, H#person.phone, H).
		
		compare(_, Phone_number, Phone_number, H) -> 	begin
								io:fwrite("Name is ~p~n", [H#person.name]),
								io:fwrite("Age: ~p~n", [H#person.age]),
								io:fwrite("Phone: ~p~n", [H#person.phone])
								end;
		compare(T, Phone_number, _, _) -> find_user(T, Phone_number).
		

	
		 
	
