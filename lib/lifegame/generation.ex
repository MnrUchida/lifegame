defmodule Lifegame.Generation do
  def next_generation do
    current_states = Lifegame.Board.get_states()
    
    current_states
    |> Stream.map(fn (current = { key, value }) ->
        Task.async(fn -> {key, next_sum(current, current_states) |> next_gen_cell(value)} end)
       end)
    |> Map.new(&Task.await/1)
    |> Lifegame.Board.update()
  end

  defp next_gen_cell(next, _cur) when next < 2, do: 0
  defp next_gen_cell(next, cur) when cur == 0 and next == 3, do: 1
  defp next_gen_cell(next, cur) when next < 4, do: cur
  defp next_gen_cell(_next, _cur), do: 0

  defp next_sum({{x,y}, value}, states) do
    Enum.reduce(-1..1, 0, 
      fn(x_inc, acc) ->
        Enum.reduce(-1..1, acc, &( &2 + (states[{x + x_inc, y + &1}] || 0)))
      end
    ) - value
  end
end
