defmodule Minesweeper do
  def get_arr([h|_t], 0), do: h
  def get_arr([_h|t], p), do: get_arr(t, p - 1)

  def update_arr([_h|t], 0, v), do: [v | t]
  def update_arr([h|t], n, v), do: [h | update_arr(t, n - 1, v)]

  def get_pos(tab, l, c), do: tab |> get_arr(l) |> get_arr(c)

  def update_pos(tab, l, c, v), do: update_arr(tab, l, update_arr(get_arr(tab, l), c, v))

  def is_mine(tab, l, c), do: get_pos(tab, l, c)

  def is_valid_pos(tamanho, l, c), do: l >= 0 and l < tamanho and c >= 0 and c < tamanho

  def valid_moves(tam, l, c) do

    moves = [
      {l-1, c-1}, {l-1, c}, {l-1, c+1},
      {l,   c-1},           {l,   c+1},
      {l+1, c-1}, {l+1, c}, {l+1, c+1}
    ]

    Enum.filter(moves, fn {nl, nc} -> is_valid_pos(tam, nl, nc) end)
  end

  def conta_minas_adj(minas, l, c) do
    adjPositions = valid_moves(length(minas), l, c)

    # Conta quantos get_pos true existem nas posições adjacentes
    Enum.count(adjPositions, fn {nl, nc} -> true and get_pos(minas, nl, nc) end)
  end

  # Alterar
  def abre_jogada(l, c, minas, tab) do
    if is_mine(minas, l, c) or is_integer(get_pos(tab, l, c)) do
      tab
    else
      qtd_minas = conta_minas_adj(minas, l, c)

      case qtd_minas do
        0 ->
          # Abre a posição
          tab = update_pos(tab, l, c, 0)

          # Recursivamente abre as adjacentes
          new_tab =
            valid_moves(length(tab), l, c)
            |> Enum.reduce(tab, fn {lt, ct}, acc_tab -> abre_jogada(lt, ct, minas, acc_tab) end)

          new_tab

        _ ->
          # Atualiza com a quantidade de minas adjacentes
          update_pos(tab, l, c, qtd_minas)
      end
    end
  end

  def abre_posicao(tab, minas, l, c) do
    cond do
      get_pos(tab, l, c) == "-" ->
        cond do
          is_mine(minas, l, c) ->
            update_pos(tab, l, c, "@")

          true ->
            n_minas = conta_minas_adj(minas, l, c)
            update_pos(tab, l, c, n_minas)
        end

      true ->
        tab
    end
  end

  def abre_tabuleiro(minas, tab) do
    Enum.reduce(0..(length(tab) - 1), tab, fn l, acc_tab ->
      Enum.reduce(0..(length(tab) - 1), acc_tab, fn c, acc_tab2 ->
        abre_posicao(acc_tab2, minas, l, c)
      end)
    end)
  end

  def board_to_string(tab) do
    tamanho = length(tab)
    borda_cima = "\n\n   #{Enum.join(1..tamanho, "   ")}  \n  ┌#{String.duplicate("───┬", tamanho - 1)}───┐"
    borda_baixo = "\n  └#{String.duplicate("───┴", tamanho - 1)}───┘"

    borda = "  ├#{String.duplicate("───┼", tamanho - 1)}───┤"

    # Define a função de ajuste de índice
    adjusted_index = fn i ->
      if i >= 10, do: "#{i}│", else: "#{i} │"
    end

    linhas = Enum.zip(1..tamanho, tab)
             |> Enum.map(fn {i, linha} -> "#{adjusted_index.(i)} #{Enum.join(linha, " │ ")} │" end)
             |> Enum.join("\n#{borda}\n")

    borda_cima <> "\n" <> linhas <> borda_baixo
  end

  def gera_lista(0, _v), do: []
  def gera_lista(n, v), do: [v | gera_lista(n - 1, v)]

  def gera_tabuleiro(n), do: Enum.map(gera_lista(n, "-"), &gera_lista(n, &1))

  def gera_mapa_de_minas(n), do: gera_lista(n, gera_lista(n, false))

  def conta_fechadas(tab) do
    Enum.reduce(tab, 0, fn l, soma ->
      soma + Enum.count(l, fn pos -> pos == "-" end)
    end)
  end

  def conta_minas(minas) do
    Enum.reduce(minas, 0, fn l, soma ->
      soma + Enum.count(l, fn pos -> pos end)
    end)
  end

  def end_game?(minas, tab), do: conta_fechadas(tab) == conta_minas(minas)
end

defmodule Motor do
  def main() do
    v = IO.gets("Digite o tamanho do tabuleiro: \n")
    {size, _} = Integer.parse(v)
    minas = gen_mines_board(size)
    # IO.inspect(minas)
    tabuleiro = Minesweeper.gera_tabuleiro(size)
    game_loop(minas, tabuleiro)
  end

  def game_loop(minas, tabuleiro) do
    IO.puts(Minesweeper.board_to_string(tabuleiro))
    v = IO.gets("Digite uma linha: \n")
    {linha, _} = Integer.parse(v)
    v = IO.gets("Digite uma coluna: \n")
    {coluna, _} = Integer.parse(v)

    if Minesweeper.is_mine(minas, linha, coluna) do
      IO.puts("VOCÊ PERDEU!!!!!!!!!!!!!!!!")
      IO.puts(Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas, tabuleiro)))
      IO.puts("TENTE NOVAMENTE!!!!!!!!!!!!")
    else
      novo_tabuleiro = Minesweeper.abre_jogada(linha, coluna, minas, tabuleiro)

      if Minesweeper.end_game?(minas, novo_tabuleiro) do
        IO.puts("VOCÊ VENCEU!!!!!!!!!!!!!!")
        IO.puts(Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas, novo_tabuleiro)))
        IO.puts("PARABÉNS!!!!!!!!!!!!!!!!!")
      else
        game_loop(minas, novo_tabuleiro)
      end
    end
  end

  def gen_mines_board(size) do
    add_mines(ceil(size * size * 0.15), size, Minesweeper.gera_mapa_de_minas(size))
  end

  def add_mines(0, _size, mines), do: mines

  def add_mines(n, size, mines) do
    linha = :rand.uniform(size - 1)
    coluna = :rand.uniform(size - 1)

    if Minesweeper.is_mine(mines, linha, coluna) do
      add_mines(n, size, mines)
    else
      add_mines(n - 1, size, Minesweeper.update_pos(mines, linha, coluna, true))
    end
  end
end

Motor.main()


  #IO.puts "Tem mina em (4, 4)? #{Minesweeper.is_mine(mines_board, 4, 4)}"
  #IO.puts "Tem mina em (5, 5)? #{Minesweeper.is_mine(mines_board, 5, 5)}"
  #IO.puts "Tem mina em (0, 0)? #{Minesweeper.is_mine(mines_board, 0, 0)}"
  #IO.puts "Tem mina em (1, 2)? #{Minesweeper.is_mine(mines_board, 1, 2)}"

  #IO.inspect Minesweeper.valid_moves(3, 0, 0) # Saída esperada: [{0, 1}, {1, 0}, {1, 1}]
  #IO.inspect Minesweeper.valid_moves(3, 1, 1) # Saída esperada: [{0, 0}, {0, 1}, {0, 2}, {1, 0}, {1, 2}, {2, 0}, {2, 1}, {2, 2}]
  #IO.inspect Minesweeper.valid_moves(3, 2, 2) # Saída esperada: [{1, 1}, {1, 2}, {2, 1}]

  #IO.inspect Minesweeper.conta_minas_adj(mines_board, 4, 5)
