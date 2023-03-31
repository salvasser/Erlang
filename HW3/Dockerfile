FROM erlang:26

COPY factorial.erl factorial.erl
RUN chmod +x factorial.erl
CMD echo "it is factorial calculator, please enter a number:" && read num && ./factorial.erl $num
