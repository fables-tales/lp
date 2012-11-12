class Board
  def initialize
    @board = make_board
  end

  def score_board(player)
    @board.flatten.select {|square| square[:color] == player}.count
  end

  def capture_square(x,y,player)
    if x >= 0 and x <= 5 and y >= 0 and y <= 5
      @board[y][x][:color] = player unless @board[y][x][:concrete]
    end
  end

  private
  def make_board
    board = []
    5.times do
      row = []
      5.times do
        row << make_square
      end
      board << row
    end
    board
  end

  def make_square
    letter = "abcdefghijklmnopqrstuvwxyz".split("").sample
    {:letter => letter, :color => nil, :concrete => false}
  end
end
