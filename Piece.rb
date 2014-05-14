#encoding: utf-8
# unicode: http://unicode-table.com/en/sections/miscellaneous-symbols/

class Piece

  WHITE = "♽"
  BLACK = "☢"
  WHITE_KING = "♼"
  BLACK_KING = "☣"
  DEATH = "☠"

  DIRECTIONS = [[]]

  attr_reader :board, :color

  attr_accessor :pos, :king

  def initialize(board, pos, color, king = false)
    raise 'invalid color' unless [:white, :black].include?(color)
    raise 'invalid pos' unless board.valid_pos?(pos)

    @board, @pos, @color = board, pos, color
    board[pos] = self
    @king = king
    @final_level = (color == :white ? 0 : 7)
  end

  def perform_slide(to_pos)
    #move diagonally one space
    #check if board.empty?(pos)
    #black moves down
    #white moves up
    #unless king = true
    if board.empty?(to_pos)
      pos = to_pos
    end
    
    check_promotion unless king
  end

  def forward
    row + (color == :white ? -1 : 1)
  end

  def perform_jump

  end

  def display
    if king
      color == :white ? self.class::WHITE_KING
                       : self.class::BLACK_KING
    else
      color == :white ? self.class::WHITE : self.class::BLACK
    end
  end

  def check_promotion #call after move
    king = true if promote?
  end

  private

  def promote?
    @final_level == pos[0]
  end
end