web_users
==================================================
This web application works with a database. 
There is user data here: their id, name, age and phone number. 
You can display the data of all users at once, display the data of one user by his ID, display the data of users older or younger than a certain age, as well as delete and add users.

------------------------------------------------
to run the application, execute in the terminal:
------------------------------------------------ 
### there are two options:
 1. Via docker compose
    ~~~bash
    docker-compose up -d
    ~~~
    ~~~bash
    docker exec -it erl /bin/bash
    ~~~
    ~~~bash
    rebar3 compile && rebar3 shell
    ~~~
    ~~~bash
    server:server().
    ~~~
 2. Via docker network
    ~~~bash
    docker image build -t webusers:1 -f Dockerfile.webusers https://github.com/salvasser/Erlang.git#main
    ~~~
    ~~~bash
    docker network create web-app
    ~~~
    ~~~bash
    docker run -d --network web-app --network-alias db -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=erlang mysql:8.0
    ~~~
    ~~~bash
    docker run -it --name users -dp 8071:8071 --network web-app webusers:1
    ~~~
    ~~~bash
    docker exec -it users /bin/bash
    ~~~
    ~~~bash
    rebar3 compile && rebar3 shell
    ~~~
    ~~~bash
    server:server().
    ~~~
------------------------------------------------
enter in the address bar of the browser
------------------------------------------------

	localhost:8071
------------------------------------------------
if you run the program again, then execute in virtual machine erlang container:
------------------------------------------------

   ~~~bash
   server:clear_data().
   ~~~
	
then restart the erlang virtual machine.
------------------------------------------------


pleasant use:)
