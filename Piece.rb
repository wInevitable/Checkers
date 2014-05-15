#encoding: utf-8
# unicode: http://unicode-table.com/en/sections/miscellaneous-symbols/

class Piece

  #move to display method?
  DEATH = "☠"

  attr_reader :board, :color, :between

  attr_accessor :pos, :king

  def initialize(board, pos, color, king = false)
    raise 'invalid color' unless [:white, :black].include?(color)
    raise 'invalid pos' unless board.valid_pos?(pos)
    @board, @pos, @color = board, pos, color
    board[pos] = self
    @king = king
  end

  def display
    if king
      color == :white ? "♼" : "☣"
    else
      color == :white ? "♽" : "☢"
    end
  end
  
  #selects valid moves from all possible moves
  def valid_moves
    moves.select do |end_pos|
      board.valid_pos?(end_pos) && board.empty?(end_pos)
    end
  end
  
  def perform_moves!(move_sequence)
    #takes in either one slide of one or more jumps
    #so an array of count 1 or greater
  end
  
  def check_promotion
    self.king = true if pos[0] == (color == :white ? 0 : 7)
  end
  
  private
  
  #returns all possible moves
  def moves
    sliding_moves + jumping_moves
  end
  
  def sliding_moves
    #move diagonally one space
    sliding_moves = [[sliding_row, pos[1] + 1],
                     [sliding_row, pos[1] - 1]]
    if king
      sliding_moves += [[-sliding_row, pos[1] + 1],
                        [-sliding_row, pos[1] - 1]]
    end
    sliding_moves
  end
  
  def sliding_row
    #black moves down, white moves up
    pos[0] + (color == :white ? -1 : 1)
  end
  
  def jumping_moves
    #jump row +- 2, col +- 2
    jumping_moves = [[jumping_row, pos[1] + 2],
                     [jumping_row, pos[1] - 2]]
    if king
      jumping_moves += [[-jumping_row, pos[1] + 2],
                        [-jumping_row, pos[1] - 2]]
    end
    #check for piece in between
    jumping_moves.select do |jump|
      board.has_enemy?(self, jump)
    end
  end

  def jumping_row
    pos[0] + (color == :white ? -2 : 2)
  end
end