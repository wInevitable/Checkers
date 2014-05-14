#encoding: utf-8

class Board
  
  def initialize(new_game = true)
    build_grid(new_game)
  end
    
  def add_piece(piece, pos)
    
  end
    
  protected
  
  def build_grid(new_game)
    @rows = Array.new(8) { Array.new(8) }
    return unless new_game
    
    [:white, :black].each do |color|
        fill_back_row(color)
        fill_front_row(color)
    end
    nil
  end
  
  def fill_back_row(color)
    #black on top, white at the bottom
    #board indices start 0,0 in top left corner to 7,7
    i = (color == white ? 7 : 0 )
    @rows[i].each do |j|
      if (i + j).odd?
        Piece.new(self, [i, j], color)
      end
    end
  end
  
  def fill_front_row(color)
    i = (color == white ? 6 : 1)
    @rows[i].each do |j|
      if (i + j).odd?
        Piece.new(self, [i, j], color)
      end
    end
  end
end