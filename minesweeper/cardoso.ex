defmodule Minesweeper do
  def get_arr([h | _t], 0), do: h
  def get_arr([_h | t], n), do: get_arr(t, n - 1)

  def update_arr([_h | t], 0, v), do: [v | t]
  def update_arr([h | t], n, v), do: [h | update_arr(t, n - 1, v)]

  def get_pos(tab, l, c), do: get_arr(get_arr(tab, l), c)

  def update_pos(tab, l, c, v), do: update_arr(tab, l, update_arr(get_arr(tab, l), c, v))

  def is_mine(tab, l, c), do: get_pos(tab, l, c)

  def is_valid_pos(tamanho, l, c), do: l >= 0 and l < tamanho and c >= 0 and c < tamanho

  def valid_moves(tamanho, l, c),
    do:
      [
        {l - 1, c - 1},
        {l - 1, c},
        {l - 1, c + 1},
        {l, c - 1},
        {l, c + 1},
        {l + 1, c - 1},
        {l + 1, c},
        {l + 1, c + 1}
      ]
      |> Enum.filter(fn {lt, ct} -> is_valid_pos(tamanho, lt, ct) end)

  def conta_minas_adj(tab, l, c) do
    valid_moves(length(tab), l, c) |> Enum.count(fn {lt, ct} -> is_mine(tab, lt, ct) end)
  end

  def abre_jogada(l, c, minas, tab) do
    if is_mine(minas, l, c) or is_integer(get_pos(tab, l, c)) do
      tab
    else
      qtd_minas = conta_minas_adj(minas, l, c)

      tab =
        case qtd_minas do
          0 ->
            # Abre a posição
            tab = update_pos(tab, l, c, 0)

            # Recursivamente abre as adjacentes
            valid_moves(length(tab), l, c)
            |> Enum.reduce(tab, fn {lt, ct}, acc_tab -> abre_jogada(lt, ct, minas, acc_tab) end)

          _ ->
            # Atualiza com a quantidade de minas adjacentes
            update_pos(tab, l, c, qtd_minas)
        end

      tab
    end
  end

  def abre_posicao(tab, minas, l, c) do
    case get_pos(tab, l, c) do
      # se está fechada
      "■" ->
        case is_mine(minas, l, c) do
          true ->
            update_pos(tab, l, c, "Ø")

          false ->
            n_minas = conta_minas_adj(minas, l, c)
            update_pos(tab, l, c, n_minas)
        end

      _ ->
        tab
    end
  end

  def abre_tabuleiro(minas, tab) do
    Enum.reduce(0..(length(tab) - 1), tab, fn l, soma ->
      Enum.reduce(0..(length(tab) - 1), soma, fn c, soma2 ->
        abre_posicao(soma2, minas, l, c)
      end)
    end)
  end

  ########################################################################################

  def board_to_string(tab) do
    Enum.join(
      [
        print_borda_cima(length(tab)),
        print_linhas(tab),
        print_borda_baixo(length(tab))
      ],
      "\n"
    )
  end

  defp print_borda_cima(tamanho) do
    "\n\n╔#{String.duplicate("═══╦", tamanho - 1)}═══╗"
  end

  defp print_borda_baixo(tamanho) do
    "╚#{String.duplicate("═══╩", tamanho - 1)}═══╝\n\n"
  end

  defp print_borda(tamanho) do
    "╠#{String.duplicate("═══╬", tamanho - 1)}═══╣"
  end

  defp print_linhas(tab) do
    Enum.join(Enum.map(tab, &print_linha(&1)), "\n#{print_borda(length(tab))}\n")
  end

  defp print_linha(linha) do
    "#{Enum.join(Enum.map(linha, &print_pos(&1)), "")}║"
  end

  defp print_pos(pos) do
    "║ #{pos} "
  end

  ########################################################################################

  def gera_lista(0, _v), do: []
  def gera_lista(n, v), do: [v | gera_lista(n - 1, v)]

  def gera_tabuleiro(n), do: Enum.map(gera_lista(n, "■"), &gera_lista(n, &1))

  def gera_mapa_de_minas(n), do: gera_lista(n, gera_lista(n, false))

  def conta_fechadas(tab) do
    Enum.reduce(tab, 0, fn l, soma ->
      soma + Enum.count(l, fn pos -> pos == "■" end)
    end)
  end

  def conta_minas(minas) do
    Enum.reduce(minas, 0, fn l, soma ->
      soma + Enum.count(l, fn pos -> pos end)
    end)
  end

  def end_game?(minas, tab), do: conta_fechadas(tab) == conta_minas(minas)
end

###################################################################
###################################################################

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
