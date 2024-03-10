defmodule Minesweeper do
  # Retorna o elemento na posição do vetor.
  def get_arr([h|_t], 0), do: h
  def get_arr([_h|t], p), do: get_arr(t, p - 1)

  # Atualiza o elemento na posição do vetor.
  def update_arr([_h|t], 0, v), do: [v | t]
  def update_arr([h|t], n, v), do: [h | update_arr(t, n - 1, v)]

  # Retorna o valor na posição especificada do tabuleiro.
  def get_pos(tab, l, c), do: tab |> get_arr(l) |> get_arr(c)

  # Atualiza o valor na posição especificada do tabuleiro.
  def update_pos(tab, l, c, v), do: update_arr(tab, l, update_arr(get_arr(tab, l), c, v))

  # Verifica se há uma mina na posição especificada do tabuleiro.
  def is_mine(tab, l, c), do: get_pos(tab, l, c)

  # Verifica se a posição especificada está dentro dos limites do tabuleiro.
  def is_valid_pos(tamanho, l, c), do: l >= 0 and l < tamanho and c >= 0 and c < tamanho

  # Retorna uma lista de movimentos válidos a partir da posição especificada.
  def valid_moves(tam, l, c) do
    moves = [
      {l-1, c-1}, {l-1, c}, {l-1, c+1},
      {l,   c-1},           {l,   c+1},
      {l+1, c-1}, {l+1, c}, {l+1, c+1}
    ]
    Enum.filter(moves, fn {nl, nc} -> is_valid_pos(tam, nl, nc) end)
  end

  # Conta o número de minas adjacentes à posição especificada do tabuleiro.
  def conta_minas_adj(minas, l, c) do
    adjPositions = valid_moves(length(minas), l, c)
    Enum.count(adjPositions, fn {nl, nc} -> true and get_pos(minas, nl, nc) end)
  end

  # Abre uma jogada no tabuleiro, revelando as posições adjacentes se não houver mina na posição especificada.
  def abre_jogada(l, c, minas, tab) do
    if is_mine(minas, l, c) or is_integer(get_pos(tab, l, c)) do # Existe mina ou a posição já está aberta?
      tab # Retorna o tabuleiro
    else
      qtd_minas = conta_minas_adj(minas, l, c)  # Caso contrário, conta o número de minas adjacentes à posição especificada.
      case qtd_minas do 0 -> # Verifica se não há minas adjacentes.
          tab = update_pos(tab, l, c, 0) # Se não houver minas adjacentes, atualiza a posição com 0 (vazia).
          # Em seguida, abre recursivamente as posições adjacentes.
          new_tab = valid_moves(length(tab), l, c) |> Enum.reduce(tab, fn {lt, ct}, acc_tab -> abre_jogada(lt, ct, minas, acc_tab) end)
          new_tab
        _ ->
          # Se houver minas adjacentes, atualiza a posição com a quantidade de minas.
          update_pos(tab, l, c, qtd_minas)
      end
    end
  end

  # Abre uma posição no tabuleiro, revelando minas ou contando minas adjacentes.
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

  # Abre todas as posições seguras do tabuleiro, revelando minas ou contando minas adjacentes.
  def abre_tabuleiro(minas, tab) do
    Enum.reduce(0..(length(tab) - 1), tab, fn l, acc_tab ->
      Enum.reduce(0..(length(tab) - 1), acc_tab, fn c, acc_tab2 ->
        abre_posicao(acc_tab2, minas, l, c)
      end)
    end)
  end

  # Formata um número para exibição no tabuleiro, adicionando espaço se necessário.
  def format_number(number) when number < 10, do: " #{number}"
  def format_number(number), do: "#{number}"

  # Converte o tabuleiro em uma representação de string para exibição.
  def board_to_string(tab) do
    tamanho = length(tab)
    # Linha superior (números + colunas) e linha inferior.
    borda_cima = "\n\n   #{Enum.map(0..tamanho - 1, &format_number/1) |> Enum.join("  ")}  \n  ┌#{String.duplicate("───┬", tamanho - 1)}───┐"
    borda_baixo = "\n  └#{String.duplicate("───┴", tamanho - 1)}───┘"
    borda = "  ├#{String.duplicate("───┼", tamanho - 1)}───┤"    # Cria a linha de separação entre as linhas do tabuleiro.
    # Função para ajustar o índice das linhas do tabuleiro, adicionando um espaço adicional para números de duas ou mais casas.
    adjusted_index = fn i ->
      if i >= 10, do: "#{i}│", else: "#{i} │"
    end

    # Gera as linhas do tabuleiro, formatando cada linha com os números das linhas e as células do tabuleiro.
    linhas = Enum.zip(0..tamanho - 1, tab)
             |> Enum.map(fn {i, linha} -> "#{adjusted_index.(i)} #{Enum.join(linha, " │ ")} │" end)
             |> Enum.join("\n#{borda}\n")

    # Retorna o tabuleiro completo como uma string concatenando a borda superior, as linhas e a borda inferior.
    borda_cima <> "\n" <> linhas <> borda_baixo
  end

  # Gera uma lista com n elementos iguais a v.
  def gera_lista(0, _v), do: []
  def gera_lista(n, v), do: [v | gera_lista(n - 1, v)]

  # Gera um tabuleiro de tamanho n com todas as posições fechadas.
  def gera_tabuleiro(n), do: Enum.map(gera_lista(n, "-"), fn _ -> gera_lista(n, "-") end)

  # Gera um mapa de minas de tamanho n com todas as posições sem minas.
  def gera_mapa_de_minas(n), do: gera_lista(n, gera_lista(n, false))

  # Conta o número de posições fechadas no tabuleiro.
  def conta_fechadas(tab) do
    Enum.reduce(tab, 0, fn l, soma ->
      soma + Enum.count(l, fn pos -> pos == "-" end)
    end)
  end

  # Conta o número total de minas no tabuleiro de minas.
  def conta_minas(minas) do
    Enum.reduce(minas, 0, fn l, soma ->
      soma + Enum.count(l, fn pos -> pos end)
    end)
  end

  # Verifica se o jogo terminou (todas as posições seguras foram abertas).
  def end_game?(minas, tab), do: conta_fechadas(tab) == conta_minas(minas)
end

defmodule Motor do
  def main() do
    v = IO.gets("Tamanho do Tabuleiro: \n")
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
      IO.puts("Você Perdeu!")
      IO.puts(Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas, tabuleiro)))
      IO.puts("Tente novamente.")
    else
      novo_tabuleiro = Minesweeper.abre_jogada(linha, coluna, minas, tabuleiro)

      if Minesweeper.end_game?(minas, novo_tabuleiro) do
        IO.puts("Você Venceu!")
        IO.puts(Minesweeper.board_to_string(Minesweeper.abre_tabuleiro(minas, novo_tabuleiro)))
        IO.puts("Parabéns!")
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
