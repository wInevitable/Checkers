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

  def dup
    new_board = Board.new(false)
    pieces.each do |piece|
      Piece.new(new_board, piece.pos, piece.color, piece.king)
    end
    new_board
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
    
  def pieces(color = nil)
    pieces = @board.flatten.compact
    if color
      pieces.select { |piece| piece.color == color}
    end
    pieces
  end

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