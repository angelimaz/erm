defmodule ErmWeb.PartnerController do
  use ErmWeb, :controller

  alias Erm.Entities
  alias Erm.Entities.Partner
  alias Erm.Accounts

  # def index(conn, _params) do
  #   partners = Entities.list_parters()
  #   render(conn, "index.html", parters: parters)
  # end

  def new(conn, _params) do
    changeset = Entities.change_partner(%Partner{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"partner" => partner_params}) do
    #case Entities.create_partner(partner_params) do
    case Erm.Accounts.create_identity(partner_params) do
      {:ok, authentication} ->
        conn
        |> put_flash(:info, "Partner created successfully.")
        |> Accounts.sign_in(authentication.partner)
        |> redirect(to: "/home")

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts "error changset in controller partner"
        IO.inspect changeset
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   partner = Entities.get_partner!(id)
  #   render(conn, "show.html", partner: partner)
  # end

  # def edit(conn, %{"id" => id}) do
  #   partner = Entities.get_partner!(id)
  #   changeset = Entities.change_partner(partner)
  #   render(conn, "edit.html", partner: partner, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "partner" => partner_params}) do
  #   partner = Entities.get_partner!(id)

  #   case Entities.update_partner(partner, partner_params) do
  #     {:ok, partner} ->
  #       conn
  #       |> put_flash(:info, "Partner updated successfully.")
  #       |> redirect(to: Routes.partner_path(conn, :show, partner))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", partner: partner, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   partner = Entities.get_partner!(id)
  #   {:ok, _partner} = Entities.delete_partner(partner)

  #   conn
  #   |> put_flash(:info, "Partner deleted successfully.")
  #   |> redirect(to: Routes.partner_path(conn, :index))
  # end
end
