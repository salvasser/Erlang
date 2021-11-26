-module (file_reading).
-export ([read/1]).


%	given 'hello.dat' as an arument 
read(Filename) ->
	
	Touple = file:read_file(Filename),
	{ok, Data} = Touple,
	erlang:binary_to_list(Data).
	
