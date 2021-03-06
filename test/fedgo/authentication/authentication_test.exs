defmodule Fechgo.AuthenticationTest do
  use Fechgo.DataCase

  alias Fechgo.Authentication

  describe "users" do
    alias Fechgo.Authentication.User

    @valid_attrs %{email: "some email", name: "some name", password_hash: "some password_hash", username: "some username"}
    @update_attrs %{email: "some updated email", name: "some updated name", password_hash: "some updated password_hash", username: "some updated username"}
    @invalid_attrs %{email: nil, name: nil, password_hash: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authentication.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Authentication.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Authentication.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Authentication.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.password_hash == "some password_hash"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authentication.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Authentication.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.password_hash == "some updated password_hash"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Authentication.update_user(user, @invalid_attrs)
      assert user == Authentication.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Authentication.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Authentication.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Authentication.change_user(user)
    end
  end
end
