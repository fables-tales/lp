require "set"

class Board
  WORDS = Set.new(open("/usr/share/dict/words").read.strip.split("\n"))
  def initialize
    @board = make_board
  end

  def to_s
    @board.map do |row|
      p1 = row.map {|cell| {nil => ".",
                            :player => "P",
                            :opponent => "o"}[cell[:color]]}.join(" ")
      p2 = row.map {|cell| cell[:letter]}.join(" ")
      "#{p1} #{p2}"
    end.join("\n")
  end

  def score_board(player)
    @board.flatten.select {|square| square[:color] == player}.count
  end

  def capture_square(x,y,player)
    if x >= 0 and x <= 5 and y >= 0 and y <= 5
      @board[y][x][:color] = player unless @board[y][x][:concrete]
    end
  end

  def has_letters?(word)
    all_letters.select{|letter| word.include? letter}.uniq.size == word.size
  end

  def update_concreteness
    5.times do |y|
      5.times do |x|
        c = neighbor_count x,y
        required = 4
        required -= 1 if isedgey y
        required -= 1 if isedgex x
        if c >= required and @board[y][x][:color] != nil
          concrete x,y
        end
      end
    end
  end

  def cell(x,y)
    @board[y][x]
  end

  private

  def neighbor_count(x, y)
    current_color = @board[y][x][:color]
    r = 0
    r += 1 if @board[y-1][x][:color] == current_color unless y == 0
    r += 1 if @board[y+1][x][:color] == current_color unless y == 4
    r += 1 if @board[y][x+1][:color] == current_color unless x == 4
    r += 1 if @board[y][x-1][:color] == current_color unless x == 0
    return r
  end

  def concrete(x,y)
    @board[y][x][:concrete] = true
  end

  def isedgey(y)
    return y == 0 || y == 4
  end

  def isedgex(x)
    return x == 0 || x == 4
  end

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
