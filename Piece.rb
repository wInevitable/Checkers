#encoding: utf-8
# unicode: http://www.unicode.org/charts/PDF/U2600.pdf

class Piece
  
  WHITE = "\u26C0"
  BLACK = "\u26C2"
  WHITE_KING = "\u26c1"
  BLACK_KING = "\u26C3"
  #use panmetal.de?
  
  DIRECTIONS = [[]]
  
  attr_reader :board, :color
  
  attr_accessor :pos, :king
  
  def initialize(board, pos, color, king = false)
    raise 'invalid color' unless [:white, :black].include?(color)
    raise 'invalid pos' unless board.valid_pos?(pos)
    
    @board, @pos, @color = board, pos, color
    board[pos] = self
    @king = king
  end
  
  def perform_slide
    
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
end