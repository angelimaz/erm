defmodule Erm.EntitiesTest do
  use Erm.DataCase

  alias Erm.Entities

  describe "entities" do
    alias Erm.Entities.Approval

    @valid_attrs %{content: %{}, title: "some title", type: "some type"}
    @update_attrs %{content: %{}, title: "some updated title", type: "some updated type"}
    @invalid_attrs %{content: nil, title: nil, type: nil}

    def approval_fixture(attrs \\ %{}) do
      {:ok, approval} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Entities.create_approval()

      approval
    end

    test "list_entities/0 returns all entities" do
      approval = approval_fixture()
      assert Entities.list_entities() == [approval]
    end

    test "get_approval!/1 returns the approval with given id" do
      approval = approval_fixture()
      assert Entities.get_approval!(approval.id) == approval
    end

    test "create_approval/1 with valid data creates a approval" do
      assert {:ok, %Approval{} = approval} = Entities.create_approval(@valid_attrs)
      assert approval.content == %{}
      assert approval.title == "some title"
      assert approval.type == "some type"
    end

    test "create_approval/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entities.create_approval(@invalid_attrs)
    end

    test "update_approval/2 with valid data updates the approval" do
      approval = approval_fixture()
      assert {:ok, %Approval{} = approval} = Entities.update_approval(approval, @update_attrs)
      assert approval.content == %{}
      assert approval.title == "some updated title"
      assert approval.type == "some updated type"
    end

    test "update_approval/2 with invalid data returns error changeset" do
      approval = approval_fixture()
      assert {:error, %Ecto.Changeset{}} = Entities.update_approval(approval, @invalid_attrs)
      assert approval == Entities.get_approval!(approval.id)
    end

    test "delete_approval/1 deletes the approval" do
      approval = approval_fixture()
      assert {:ok, %Approval{}} = Entities.delete_approval(approval)
      assert_raise Ecto.NoResultsError, fn -> Entities.get_approval!(approval.id) end
    end

    test "change_approval/1 returns a approval changeset" do
      approval = approval_fixture()
      assert %Ecto.Changeset{} = Entities.change_approval(approval)
    end
  end
end
