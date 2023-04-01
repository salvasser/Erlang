web_users
==================================================
This web application works with a database. 
There is user data here: their id, name, age and phone number. 
You can display the data of all users at once, display the data of one user by his ID, display the data of users older or younger than a certain age, as well as delete and add users.

------------------------------------------------
to run the application, execute in the terminal:
------------------------------------------------ 
## there are two options:
 1. Via docker compose
	1.1. docker-compose up -d
	1.2. docker exec -it erl /bin/bash
	1.3. rebar3 compile && rebar3 shell
	1.4. server:server().
 2. Via docker network
------------------------------------------------
enter in the address bar of the browser
------------------------------------------------

	localhost:8071.
------------------------------------------------
if you run the program again, then execute in virtual machine erlang container:
------------------------------------------------

	server:clear_data().
	
then restart the erlang virtual machine.
------------------------------------------------


pleasant use:)
