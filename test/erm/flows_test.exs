defmodule Erm.FlowsTest do
  use Erm.DataCase

  alias Erm.Flows

  describe "flows" do
    alias Erm.Flows.Flow

    @valid_attrs %{content: %{}, name: "some name", process: "some process", type: "some type"}
    @update_attrs %{content: %{}, name: "some updated name", process: "some updated process", type: "some updated type"}
    @invalid_attrs %{content: nil, name: nil, process: nil, type: nil}

    def flow_fixture(attrs \\ %{}) do
      {:ok, flow} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Flows.create_flow()

      flow
    end

    test "list_flows/0 returns all flows" do
      flow = flow_fixture()
      assert Flows.list_flows() == [flow]
    end

    test "get_flow!/1 returns the flow with given id" do
      flow = flow_fixture()
      assert Flows.get_flow!(flow.id) == flow
    end

    test "create_flow/1 with valid data creates a flow" do
      assert {:ok, %Flow{} = flow} = Flows.create_flow(@valid_attrs)
      assert flow.content == %{}
      assert flow.name == "some name"
      assert flow.process == "some process"
      assert flow.type == "some type"
    end

    test "create_flow/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Flows.create_flow(@invalid_attrs)
    end

    test "update_flow/2 with valid data updates the flow" do
      flow = flow_fixture()
      assert {:ok, %Flow{} = flow} = Flows.update_flow(flow, @update_attrs)
      assert flow.content == %{}
      assert flow.name == "some updated name"
      assert flow.process == "some updated process"
      assert flow.type == "some updated type"
    end

    test "update_flow/2 with invalid data returns error changeset" do
      flow = flow_fixture()
      assert {:error, %Ecto.Changeset{}} = Flows.update_flow(flow, @invalid_attrs)
      assert flow == Flows.get_flow!(flow.id)
    end

    test "delete_flow/1 deletes the flow" do
      flow = flow_fixture()
      assert {:ok, %Flow{}} = Flows.delete_flow(flow)
      assert_raise Ecto.NoResultsError, fn -> Flows.get_flow!(flow.id) end
    end

    test "change_flow/1 returns a flow changeset" do
      flow = flow_fixture()
      assert %Ecto.Changeset{} = Flows.change_flow(flow)
    end
  end
end
