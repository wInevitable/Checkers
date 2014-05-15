#encoding: utf-8

class Board

  attr_reader :board

  def initialize(new_game = true)
    build_grid(new_game)
  end

  def add_piece(piece, pos)
    raise "this town ain't big enough for the both of us
           - find another position." unless empty?(pos)
    self[pos] = piece
  end

  def empty?(pos)
    self[pos].nil?
  end

  def [](pos)
    raise 'Pick a spot between 00-77. Row first.' unless valid_pos?(pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, draught)
    raise 'Pick a spot between 00-77. Row first.' unless valid_pos?(pos)
    row, col = pos
    @board[row][col] = draught
  end

  def valid_pos?(pos)
    pos.all? { |coor| coor.between?(0, 7) }
  end

  def display #add r,w,b background!
    puts '   ' + ('A'..'H').to_a.join("  ")
    board.each_index do |row|
      print (8 - row).to_s + ' '
      board[row].each_with_index do |tile, col|
        pos = (tile.nil? ? ' ' : tile.display).center(3)
        if (row + col).odd?
          pos = pos.colorize(:background => :white)
        else
          pos = pos.colorize(:background => :red)
        end
        print pos
      end
      puts
    end
  end
  
  def move(from_pos, to_pos)
    draught = self[from_pos]
    if draught.valid_moves.include?(to_pos)
      draught.pos = to_pos
      draught.check_promotion
      self[from_pos] = nil
      self[to_pos] = draught
    end
    
    #check for jumping move
    if (from_pos[0] + to_pos[0]).even?
      self[mid_pos(from_pos, to_pos)] = nil
    end
  end
  
  def has_enemy?(piece, to_pos)
    pos = mid_pos(piece.pos, to_pos)
    !self.empty?(pos) && self[pos].color != piece.color
  end
  
  def mid_pos(from_pos, to_pos)
    mid_pos = []
    mid_pos[0] = (to_pos[0] + from_pos[0]) / 2
    mid_pos[1] = (to_pos[1] + from_pos[1]) / 2
    mid_pos
  end

  protected

  def build_grid(new_game)
    @board = Array.new(8) { Array.new(8) }
    return unless new_game

    [:white, :black].each do |color|
        fill_board(color)
    end
  end

  private

  def fill_board(color)
    row = (color == :white ? [7, 6, 5] : [0, 1, 2])
    row.each do |i|
      @board[i].each_index do |j|
        if (i + j).odd?
          Piece.new(self, [i, j], color)
        end
      end
    end
  end
end