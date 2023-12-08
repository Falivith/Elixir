defmodule L4 do
  def insertion_sort([]) do
    []
  end

  def insertion_sort([h|t]) do
    ins(h, insertion_sort(t))
  end

  def ins(e, []) do
    [e]
  end

  def ins(x, [h|t]) do
    cond do
      x <= h -> [x | [h | t]]
      true -> [h | ins(x, t)]
    end
  end

  def menor([h|t]) do
    hd(insertion_sort([h | t]))
  end

  def maior([]) do
    []
  end

  def maior([h|t]) do
    insertion_sort([h | t])
  end
end

defmodule L4_2 do
  def insertion_sort([]) do
    []
  end

  def insertion_sort([h|t]) do
    ins(h, insertion_sort(t))
  end

  def ins(e, []) do
    [e]
  end

  def ins(x, [h|t]) do
    cond do
      x == h -> [h | t]
      x <= h -> [x | [h | t]]
      true -> [h | ins(x, t)]
    end
  end
end

defmodule L4_3 do
  def insertion_sort([]) do
    []
  end

  def insertion_sort([h|t]) do
    ins(h, insertion_sort(t))
  end

  def ins(e, []) do
    [e]
  end

  def ins(x, [h|t]) do
    cond do
      x >= h -> [x | [h | t]]
      true -> [h | ins(x, t)]
    end
  end
end
