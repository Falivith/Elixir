defmodule Area do
  def area({:quadrado, lado}), do: lado * lado
  def area({:retangulo, base, altura}), do: base * altura
  def area({:circulo, raio}), do: :math.pi() * :math.pow(raio,2)
end

defmodule L5 do
  def soma_tuplas({{a, b}, {c, d}}) do
    a + b + c + d
  end

  def shift({{x, y}, z}) do
    {x, {y, z}}
  end

  def min_e_max(a, b, c) do
    {min(min(a, b), c), max(max(a, b), c)}
  end

  def soma_tupla({a, b}) do
    a + b
  end

  def soma_lista_tuplas([]) do
     0
  end

  def soma_lista_tuplas([h|t]) do
    soma_tupla(h) + soma_lista_tuplas(t)
  end

  def zip([], _) do
    []
  end

  def zip(_, []) do
    []
  end

  def zip([h1 | t1], [h2 | t2]) do
    [{h1, h2} | zip(t1, t2)]
  end

  def zip_tres([], _, _), do: []
  def zip_tres(_, [], _), do: []
  def zip_tres(_, _, []), do: []

  def zip_tres([h1 | t1], [h2 | t2], [h3 | t3]) do
    [{h1, h2, h3} | zip_tres(t1, t2, t3)]
  end

end
