defmodule RequestError do
	defexception message: "Invalid request. Possible queries: all_users, one_user, users_older, users_younger, find_by_name"
end
