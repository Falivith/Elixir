defmodule Basics do
  def sum(x, y) do
    x + y
  end
end

defmodule L1 do

  def tres_iguais(x, y, z) do
    x == y && y == z
  end

  def quatro_iguais(v, x, y, z) do
    v == x && x == y && y == z && z == v
  end

  def quantos_iguais(x, y, z) do
    cond do
      x == y && y == z -> 3
      x != y && y != z && z != y -> 0
      true -> 2
    end
  end

  def todos_diferentes(x, y, z) do
    cond do
      x != y && y != z && z != x -> true
      true -> false
    end
  end

  # def todos_diferentes(n, m, p), do: n != m && m != p
  # Nessa implementação, P pode ser igual a N. Falta esse teste

  def quantos_iguais_2(x, y, z) do
    cond do
      todos_diferentes(x, y, z) == true -> 0
      tres_iguais(x, y, z) == true -> 3
      true -> 2
    end
  end

  def elevado_dois(n), do: n * n

  def elevado_quatro(n), do: elevado_dois(n) * elevado_dois(n)

 # def palindromo?([char | resto]) do
 #   IO.puts(char)
 #   palindromo?(resto)
 # end

  def verifica_triangulo(x, y, z) do
    if x + y > z && x + z > y && z + y > x do
      true
    else
      false
    end
  end

  def sinal(int) do
      if int * -1 > 0 do
        -1
      else if int * -1 < 0 do
        1
      else
        0
      end
    end
  end
end

#IO.puts L1.quatro_iguais(10, 10, 10, 10)
#IO.puts L1.quatro_iguais(10, 1, 1, 1)

#IO.puts L1.quantos_iguais(10, 10, 10)
#IO.puts L1.quantos_iguais(1, 10, 10)
#IO.puts L1.quantos_iguais(1, 2, 3)

#IO.puts L1.todos_diferentes(1, 2, 3)
#IO.puts L1.todos_diferentes(1, 1, 3)
#IO.puts L1.todos_diferentes(2, 2, 3)

#IO.puts L1.quantos_iguais_2(10, 10, 10)
#IO.puts L1.quantos_iguais_2(1, 10, 10)
#IO.puts L1.quantos_iguais_2(1, 2, 3)

#IO.puts L1.elevado_dois(3)
#IO.puts L1.elevado_dois(4)
#IO.puts L1.elevado_dois(1)

#IO.puts L1.elevado_quatro(3)
IO.puts L1.elevado_quatro(4)
#IO.puts L1.elevado_quatro(2)
