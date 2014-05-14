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
  
  def display
    puts '   ' + ('A'..'H').to_a.join(" ")
    @board.each_index do |row|
      print (8 - row).to_s + ' '
      @board[row].each_with_index do |tile, col|
        pos = (tile.nil? ? ' ' : tile.display).center(3)
        pos = pos.colorize(:background => :light_black) if (row + col).odd?
        print pos
      end
      puts
    end
  end
  #Fix bugs and Add valid_pos? and display Board methods
  
  protected
  
  def build_grid(new_game)
    @board = Array.new(8) { Array.new(8) }
    return unless new_game
    
    [:white, :black].each do |color|
        fill_back_row(color)
        fill_middle_row(color)
        fill_front_row(color)
    end
  end
  
  def fill_back_row(color)
    #black on top, white at the bottom
    #board indices start 0,0 in top left corner to 7,7
    i = (color == :white ? 7 : 0 )
    @board[i].each_index do |j|
      if (i + j).odd?
        Piece.new(self, [i, j], color)
      end
    end
  end
  
  def fill_middle_row(color)
    i = (color == :white ? 6 : 1)
    @board[i].each_index do |j|
      if (i + j).odd?
        Piece.new(self, [i, j], color)
      end
    end
  end
  
  def fill_front_row(color)
    i = (color == :white ? 5 : 2)
    @board[i].each_index do |j|
      if (i + j).odd?
        Piece.new(self, [i, j], color)
      end
    end
  end
end