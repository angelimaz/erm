# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Erm.Repo.insert!(%Erm.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

#create admin user
alias Erm.Repo

IO.puts "Start default seeding"

{:ok, auth} = Erm.Accounts.create_identity(%{"first_name" => "Ninja", "last_name" => "Admin", "email" => "admin@allset.consulting", "password" => "DemoDemo", "password_confirmation" => "DemoDemo"})
|> IO.inspect()


{:ok, role} = Erm.Authorizations.create_role(%{"name" => "ninja role", "type" => "ninja", "content" => ":admin"})

auth.partner
|> Repo.preload(:roles) # Load existing data
|> Ecto.Changeset.change() # Build the changeset
|> Ecto.Changeset.put_assoc(:roles, [role]) # Set the association
|> Repo.update!()


