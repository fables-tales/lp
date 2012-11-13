require "set"

class Board
  WORDS = Set.new(open("/usr/share/dict/words").read.strip.split("\n"))
  def initialize(letters=nil)
    @board = parse_letters(letters) || make_board
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
    all_cells.select {|square| square[:color] == player}.count
  end

  def capture_square(x,y,player)
    if x >= 0 and x <= 5 and y >= 0 and y <= 5
      cell(x,y)[:color] = player unless cell(x,y)[:concrete]
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
    current_color = cell(x,y)[:color]
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

  def make_board(letters=nil)
    board = []
    5.times do |y|
      row = []
      5.times do |x|
        letter = (letters != nil) ? letters[y*5+x] : nil
        row << make_square(letter)
      end
      board << row
    end

    return board
  end

  def make_square(letter=nil)
    letter ||= "abcdefghijklmnopqrstuvwxyz".split("").sample
    {:letter => letter, :color => nil, :concrete => false}
  end

  def parse_letters(letters)
    return nil if letters == nil or letters.size != 25
    make_board(letters)

  end

  def all_letters
    all_cells.map {|cell| cell[:letter]}
  end

  def all_cells
    @board.flatten
  end
end
