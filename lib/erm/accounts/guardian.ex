defmodule Erm.Accounts.Guardian do
  use Guardian, otp_app: :erm
  use Guardian.Permissions.Bitwise

  def subject_for_token(%{id: id}, _claims) do
    IO.puts("subject for token")
    IO.inspect(id)
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :no_resource_id}
  end

  def resource_from_claims(%{"sub" => sub} = token) do
    IO.puts("resource_from_claims")
    IO.inspect(token)

    case Erm.Entities.get_entity(sub) do
      nil ->
        {:error, :cached_key}

      entity ->
        entity = Erm.Repo.preload(entity, :roles)
        {:ok, entity}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_claims_sub}
  end

  def build_claims(claims, resource, _opts) do
    claims =
      claims
      |> encode_permissions_into_claims!(build_permissions(resource))

    {:ok, claims}
  end

  defp build_permissions(partner) do
    partner = Erm.Repo.preload(partner, :roles)
    do_build_permissions(partner.roles)
  end

  # defp build_permissions(_resource) do
  #   public_role()
  # end

  defp do_build_permissions([]) do
    public_role()
  end

  defp do_build_permissions(roles) do
    role = roles |> List.first()
    role.content
  end

  defp public_role() do
    IO.puts "public role"
    %{
      public: [
        :all
      ]
    }
  end

  # def verify_claims(mod, claims, options) do
  #   IO.puts "verify_claims"
  #   IO.inspect mod
  #   IO.inspect claims
  #   IO.inspect options
  #   {:ok, claims}
  # end
end
