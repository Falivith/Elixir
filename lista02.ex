defmodule Fat do

  def fat(n) when n <= 0 do
    1
  end

  def fat(n) do
    n * fat(n - 1)
  end

end

defmodule Vendas do
  def vendas(0), do: 33
  def vendas(1), do: 22
  def vendas(3), do: 0
  def vendas(4), do: 66
  def vendas(_n), do: 22

  def vendas_total(0) do
    vendas(0)
  end

  def vendas_total(n) do
    vendas(n) + vendas_total(n-1)
  end
end

defmodule L2 do

  def vendas(0), do: 33
  def vendas(1), do: 22
  def vendas(3), do: 0
  def vendas(4), do: 66
  def vendas(_n), do: 22

  def vendas_total(0) do
    vendas(0)
  end

  def vendas_total(n) do
    vendas(n) + vendas_total(n-1)
  end

 def maxi(n, m) do
    cond do
      n > m -> n
      true -> m
    end
 end

 def maior_venda(n) do
   case n do
    0 -> vendas(0)
    n -> maxi(maior_venda(n-1), vendas(n))
   end
 end

 def semana_max_venda(n) do
   case n do
    0 -> 0
    1 -> maior_venda(7)
    n -> semana_max_venda(n)
   end
 end

 def potencia(b, exp) do
   case exp do
    0 -> 1
    1 -> b
    exp -> b * potencia(b, exp - 1)
   end
 end

 def fib(n) do
  case n do
    0 -> 0
    1 -> 1
    n -> fib(n - 2) + fib(n - 1)
  end
 end

 def prod_misto_reverso(m, n) do
   cond do
    m > n -> 1
    true -> m * prod_misto_reverso(m + 1, n)
   end
 end
end
