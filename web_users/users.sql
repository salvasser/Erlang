create database erlang;
use erlang;

create table users2 (
	id varchar(4),
    fio varchar(255),
	phone varchar(4),
    age int
);

insert into users2 (id, fio, phone, age) values ('1', 'Jonh', 1115, 25),
												('2', 'Kevin', 1785, 18),
                                                ('3', 'Nora', 4695, 36),
                                                ('4', 'David', 3964, 40),
                                                ('5', 'Fiona', 9358, 15),
                                                ('6', 'Andrew', 2574, 60),
                                                ('7', 'Lisa', 7563, 34),
                                                ('8', 'Stanly', 2745, 51),
                                                ('9', 'Sara', 4833, 12),
                                                ('10', 'Dash', 7866, 22);

select
	id
from users2;

drop table users2


                                                