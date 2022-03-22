web_users
==================================================
This web application works with a database. 
There is user data here: their id, name, age and phone number. 
You can display the data of all users at once, display the data of one user by his ID, display the data of users older or younger than a certain age, as well as delete and add users.

------------------------------------------------
to run the application, run in the terminal
------------------------------------------------ 
docker-compose up -d
docker exec -it erl /bin/bash
rebar3 compile && rebar3 shell
server:server().
------------------------------------------------
enter in the address bar of the browser
------------------------------------------------

	localhost:8071.
------------------------------------------------
if you run the program again, then execute:
------------------------------------------------

	server:clear_data();		in container
	
then restart the erlang virtual machine.
------------------------------------------------


pleasant use:)
