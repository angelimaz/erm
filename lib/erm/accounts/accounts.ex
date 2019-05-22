defmodule Erm.Accounts do
  @moduledoc """
  The Accounts context.
  """
  # import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Ecto.Query, warn: false
  alias Erm.Repo

  alias Erm.Accounts.Authentification
  alias Erm.Entities.Partner
  alias Erm.Accounts.Guardian
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  @doc """
  Returns the list of authentifications.

  ## Examples

      iex> list_authentifications()
      [%Authentification{}, ...]

  """
  def list_authentifications do
    Repo.all(Authentification)
  end

  @doc """
  Gets a single authentification.

  Raises `Ecto.NoResultsError` if the Authentification does not exist.

  ## Examples

      iex> get_authentification!(123)
      %Authentification{}

      iex> get_authentification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_authentification!(id), do: Repo.get!(Authentification, id)

  @doc """
  Creates a authentification.

  ## Examples

      iex> create_authentification(%{field: value})
      {:ok, %Authentification{}}

      iex> create_authentification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_authentification(attrs \\ %{}) do
    %Authentification{}
    |> Authentification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a authentification.

  ## Examples

      iex> update_authentification(authentification, %{field: new_value})
      {:ok, %Authentification{}}

      iex> update_authentification(authentification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_authentification(%Authentification{} = authentification, attrs) do
    authentification
    |> Authentification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Authentification.

  ## Examples

      iex> delete_authentification(authentification)
      {:ok, %Authentification{}}

      iex> delete_authentification(authentification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_authentification(%Authentification{} = authentification) do
    Repo.delete(authentification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking authentification changes.

  ## Examples

      iex> change_authentification(authentification)
      %Ecto.Changeset{source: %Authentification{}}

  """
  def change_authentification(%Authentification{} = authentification) do
    Authentification.changeset(authentification, %{})
  end

  def get_auth_by_email_and_password(nil, _password), do: {:error, :invalid}
  def get_auth_by_email_and_password(_email, nil), do: {:error, :invalid}

  def get_auth_by_email_and_password(email, password) do
    with %Authentification{} = auth <-
           Repo.get_by(Authentification, email: String.downcase(email)),
         true <- Comeonin.Bcrypt.checkpw(password, auth.hashed_password) do
      {:ok, auth}
    else
      _ ->
        # Help to mitigate timing attacks
        Comeonin.Bcrypt.dummy_checkpw()
        {:error, :unauthorised}
    end
  end

  def authentificate_by_oauth2(%Ueberauth.Auth{provider: provider, uid: uid} = auth) do
    provider = Atom.to_string(provider)

    authentication =
      Authentification
      |> Repo.get_by(provider: provider, uid: cast_uid(uid))
      |> Repo.preload(:partner)

    case authentication do
      nil -> create_oauth2(auth)
      authentication -> {:ok, authentication}
    end
  end

  def authenticate_by_email_and_password(email, password) do
    auth =
      Authentification
      |> Repo.get_by(email: email)
      |> Repo.preload(:partner)

    cond do
      auth && auth.partner && auth.password_hash && checkpw(password, auth.password_hash) ->
        {:ok, auth}

      auth ->
        {:error, :unauthorized}

      true ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end

  defp cast_uid(uid) when is_integer(uid) do
    Integer.to_string(uid)
  end

  defp cast_uid(uid) when is_binary(uid) do
    uid
  end

  defp create_oauth2(%Ueberauth.Auth{provider: provider, uid: uid, info: info} = attrs) do
    IO.inspect attrs
    partner_attrs = extract_partner_attrs(attrs)

    auth_attrs = %{
      is_new?: true,
      provider: Atom.to_string(provider),
      uid: cast_uid(uid),
      email: info.email || uid,
      partner: partner_attrs
    }

    %Authentification{}
    |> Authentification.oauth2_changeset(auth_attrs)
    |> Repo.insert()
  end

  defp extract_partner_attrs(%{info: info}) do
    # todo we need to search to see if a partner already exists before creating a new one
    # not done now to move on to more functionality
    %{}
    |> Map.put(:title, info.name || "#{info.first_name} #{info.last_name}")
    |> Map.put(:description, info.description) || ""
  end

  defp extract_partner_attrs(%{} = attrs) do
    # todo we need to search to see if a partner already exists before creating a new one
    # not done now to move on to more functionality
    %{}
    |> Map.put(:title, "#{attrs["first_name"]} #{attrs["last_name"]}")
    |> Map.put(:description, "")
  end

  def create_identity(attrs) do
    partner_changeset = Partner.changeset(%Partner{}, attrs)
    if partner_changeset.valid? do
      do_create_identity(attrs)
    else
      partner_changeset =  %Ecto.Changeset{partner_changeset | action: :insert}
      {:error, partner_changeset}
    end
  end

  defp do_create_identity(attrs) do
    partner_attrs = extract_partner_attrs(attrs)

    auth_attrs = %{
      is_new?: true,
      provider: nil,
      email: attrs["email"],
      partner: partner_attrs,
      password: attrs["password"],
      password_confirmation: attrs["password_confirmation"]
    }

    %Authentification{}
    |> Authentification.identity_changeset(auth_attrs)
    |> Repo.insert()
  end

  def sign_in(conn, partner) do
    Guardian.Plug.sign_in(conn, partner)
  end

  def sign_out(conn) do
    Guardian.Plug.sign_out(conn)
  end

  def add_role_to_entity(entity_id, role_id) do
    partner = Erm.Entities.get_entity!(entity_id)
    role = Erm.Authorizations.get_role!(role_id)

    partner
    |> Repo.preload(:roles) # Load existing data
    |> Ecto.Changeset.change() # Build the changeset
    |> Ecto.Changeset.put_assoc(:roles, [role]) # Set the association
    |> Repo.update!()
  end
end
