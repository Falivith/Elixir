defmodule L3 do
  def soma_lista([]) do
    0
  end

  def soma_lista([h|t]) do
    h + soma_lista(t)
  end

  def quadrado_lista([]) do
    []
  end

  def quadrado_lista([h|t]) do
    [h * h | quadrado_lista(t)]
  end

  def mult_dois_lista([]) do
    []
  end

  def mult_dois_lista([h|t]) do
    [h * 2 | mult_dois_lista(t)]
  end

  def tamanho([]) do
    0
  end

  def tamanho([_|t]) do
    1 + tamanho(t)
  end

  def produto_lista([]) do
    0
  end

  def produto_lista([e]) do
    e
  end

  def produto_lista([h|t]) do
    h * produto_lista(t)
  end

  def and_lista([]) do
    true
  end

  def and_lista([h|t]) do
    h && and_lista(t)
  end

  def insere_final(e, t) do
    t ++ e
  end

  def insere_final(e, [_|t]) do
    insere_final(e, t)
  end
end

IO.puts L3.soma_lista([])

IO.puts L3.produto_lista([1, 2, 3, 4])
