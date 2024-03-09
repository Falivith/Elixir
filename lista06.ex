defmodule Parallel do
  def mp() do
    receive do
      msg -> IO.puts "Mensagem recebida: #{msg}"
    end
  end

  def rp() do
    receive do
      {:soma, n1, n2, pid} -> send(pid, n1 + n2)
        rp()
      {:mult, n1, n2, pid} -> send(pid, n1 * n2)
        rp()
      _ ->
        IO.puts("Tchombers!")
        :die
    end
  end
end

pid = spawn_link(&Parallel.rp/0)

send(pid, {:mult, 10, 20, self()})

receive do
  mult -> IO.puts("10 * 20 = #{mult}")
end

send(pid, {:soma, 50, 25, self()})

receive do
  soma -> IO.puts("50 + 25 = #{soma}")
end

send(pid, :die)
