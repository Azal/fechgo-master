defmodule Fechgo.Authentication.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Fechgo.Authentication.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :password])
    |> validate_required([:name, :username, :email, :password])
    |> validate_length(:password, min: 6)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
    %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
    put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
    _ ->
    changeset
    end
  end
end
