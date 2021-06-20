defmodule Lifegame.Board do
  @name __MODULE__

  def start_link(size) do
    Agent.start_link(fn -> initial_fnc(Enum.to_list(0..(size - 1))) end, name: @name)
  end

  def set_live(x, y),
  do: Agent.update(@name, &set_state(&1, x, y, 1))

  def set_dead(x, y),
  do: Agent.update(@name, &set_state(&1, x, y, 0))

  def get_states,
  do: Agent.get(@name, &(&1))

  def update(states),
  do: Agent.update(@name, fn _ -> states end)

  def print_states do
    key_fnc = fn {{_x, y}, _value} -> y end
    value_fnc = fn {{_x, _y}, value} -> value end
    get_states()
    |> Map.to_list()
    |> List.keysort(0)
    |> Enum.group_by(key_fnc, value_fnc)
    |> Enum.map(fn {_, values} -> Enum.join(values) end)
    |> Enum.join("\n")
  end

  defp set_state(map, x, y, state),
  do: Map.put(map, { x, y }, state)

  defp initial_fnc(list) do
    build_map = fn (x, acc) -> Enum.reduce(list, acc, &(Map.put(&2, {x, &1}, 0)) ) end
    Enum.reduce(list, %{}, build_map)
  end
end
