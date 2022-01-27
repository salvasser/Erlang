web_users
==================================================
This web application works with a database. 
There is user data here: their id, name, age and phone number. 
You can display the data of all users at once, display the data of one user by his ID, display the data of users older or younger than a certain age, as well as delete and add users.
------------------------------------------------
Before you start working with the application, you need to execute the following queries in sql:

	CREATE DATABASE erlang;
	USE erlang;
	
------------------------------------------------	
or use bash-script "start_script" in "resources" folder.

------------------------------------------------
if you run the program again, then execute:
------------------------------------------------

	server:clear_data();		(DROP TABLE users) in sql
	
------------------------------------------------	
then restart the erlang virtual machine.

------------------------------------------------
to run the application, run "server:server()" in the terminal
enter in the address bar of the browser

	localhost:8070.
------------------------------------------------
pleasant use:)
