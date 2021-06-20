defmodule Lifegame do
  @moduledoc """
  Documentation for `Lifegame`.
  """

  def output_generation(count, initial) do
    Lifegame.Board.start_link(10)
    read_initial(initial) |> Lifegame.Board.update()
      
    Enum.each(1..count, fn x ->
      Lifegame.Generation.next_generation()
      File.write("result/gen#{x}.txt", Lifegame.Board.print_states())
    end)
  end

  defp read_initial(initial) do
    File.stream!(initial, [], :line) |> Stream.with_index() |> Enum.reduce([], &set_values(&1, &2)) |> Map.new()
  end

  defp set_values({string, y}, acc) do
    String.split(String.trim(string), "", trim: true) |> Stream.with_index() |> Enum.map(fn {value, x} ->
      { {x, y}, String.to_integer(value) }
    end) |> Enum.concat(acc)
  end
end
