defmodule People do
  @moduledoc """
  Documentation for `People`.

  database application.

  ## Examples
      first execute:
      iex> People.existing_users()

      iex> People.main()
      Enter your request: all_users/one_user/users_older/users_younger/find_by_name

      If you need delete data in database execute:
      iex> People.delete_data()
  """

  def main() do
    pid = sql_start()
    idList = id_list(pid)
    nameList = name_list(pid)
    #existing_users(pid)
    request(pid, idList, nameList)
  end

  def request(pid, idList, nameList) do 
    input = IO.gets("Enter your request: ") |> String.trim
    try do
      case input do
        "all_users" -> 
          all_users(pid) |> output()
        "one_user" ->
          id = IO.gets("Enter user's id: ") |> String.trim
          try do
            if Enum.member?(idList, id) do
              one_user(pid, id) |> output()
            else
              raise IdError
            end
          rescue
            e in IdError -> e          
          end
        "users_older" ->
          {age, "\n"} = IO.gets("Enter age: ") |> Integer.parse
          older_than(pid, age) |> output()
        "users_younger" ->
          {age, "\n"} = IO.gets("Enter age: ") |> Integer.parse
          younger_than(pid, age) |> output()
        "find_by_name" ->
          name = IO.gets("Enter user's name: ") |> String.trim
          try do
          if Enum.member?(nameList, name) do
            find_by_name(pid, name) |> output()
          else
            raise NameError
          end
          rescue
            e in NameError -> e          
          end
          #find_by_name(pid, name) |> output()
        _-> raise RequestError
      end
    rescue
      e in RequestError -> e
    end
  end 

  def output([[id, name, phone, age], data]) do
    IO.puts("#{id} #{name} #{phone} #{age}")
    output_data(data)
  end

    defp output_data([]) do
      :ok
    end
    defp output_data([[headId, headName, headPhone, headAge] | tailData]) do
      IO.puts("#{headId}  #{headName}  #{headPhone}  #{headAge}")
      output_data(tailData)
    end


  def sql_start() do
    {:ok, pid} = MyXQL.start_link(username: "root", password: "password", protocol: :tcp)
    MyXQL.query!(pid, "CREATE DATABASE IF NOT EXISTS people")
    {:ok, pid} = MyXQL.start_link(username: "root", password: "password", database: "people", protocol: :tcp)
    MyXQL.query!(pid, "CREATE TABLE IF NOT EXISTS data (id VARCHAR(4), name VARCHAR(255), phone VARCHAR(4), age INT)")
    pid
  end

  def existing_users() do
    pid = sql_start()
    {:ok, data} = File.read("resources/users.dat")
    listOfData = String.split(data, [", ", "\n"])
    read(listOfData, pid)
  end

    defp read([], _) do
      :ok
    end
    defp read([headName, headPhone, headAge, headId | tailData], pid) do
      MyXQL.query!(pid, "INSERT INTO data (id, name, phone, age) VALUES (?,?,?,?)", [headId, headName, headPhone, String.to_integer(headAge)])
      read(tailData, pid)
    end
 
  def delete_data() do
    pid = sql_start()
    MyXQL.query!(pid, "DROP DATABASE people")
  end

  def all_users(pid) do
    {:ok, data} = MyXQL.query(pid, "SELECT * FROM data")
    [data.columns, data.rows]
  end

  def one_user(pid, id) do
    {:ok, data} = MyXQL.query(pid, "SELECT * FROM data WHERE id = ?", [id])
    [data.columns, data.rows]
  end

  def older_than(pid, age) do
    {:ok, data} = MyXQL.query(pid, "SELECT * FROM data WHERE age > ?", [age])
    [data.columns, data.rows]
  end 

  def younger_than(pid, age) do
    {:ok, data} = MyXQL.query(pid, "SELECT * FROM data WHERE age < ?", [age])
    [data.columns, data.rows]
  end 

  def find_by_name(pid, name) do
    {:ok, data} = MyXQL.query(pid, "SELECT * FROM data WHERE name = ?", [name])
    [data.columns, data.rows]
  end

  def id_list(pid) do
    {:ok, data} = MyXQL.query(pid, "SELECT id FROM data")
    id_list(data.rows, [])
  end
    defp id_list([], acc) do 
      acc
    end
    defp id_list([headId|tailId], acc) do
      id_list(tailId, [List.to_string(headId)|acc])
    end

  def name_list(pid) do
    {:ok, data} = MyXQL.query(pid, "SELECT name FROM data")
    name_list(data.rows, [])
  end
    defp name_list([], acc) do 
      acc
    end
    defp name_list([headId|tailId], acc) do
      name_list(tailId, [List.to_string(headId)|acc])
    end

end
