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
    @board, @pos, @color, @king = board, pos, color, king
    board[pos] = self
  end

  def display
    if king
      color == :white ? "♼" : "☣"
    else
      color == :white ? "♽" : "☢"
    end
  end
  
  def perform_moves(start, finish)
    
  end
  
  #selects valid moves from all possible moves
  def valid_moves
    moves.select do |end_pos|
      board.valid_pos?(end_pos) && board.empty?(end_pos)
    end
  end

  def valid_move_seq?(move_seq)
    start = board[move_seq[0]]
    start.perform_move!(move_seq, board.dup)
  end

  def move(from_pos, to_pos)
    if self.valid_moves.include?(to_pos)
      self.pos = to_pos
      check_promotion
      board[from_pos] = nil
      board[to_pos] = self
    end

    #check for jumping move
    if (from_pos[0] + to_pos[0]).even?
      board[mid_pos(from_pos, to_pos)] = nil
    end
  end 

  def perform_moves!(move_sequence, dup_board)
    if move_sequence.count == 1
      valid = pos.valid_moves.include?(move_sequence[0])
    else
      #valid = ?
    end
    #multiple jumps...
    
    if valid
      #execute move
    else
      #raise an InvalidMoreError if sequence fails
    end
  end
  
  def valid_move_seq?
    #calls perform_moves! on a duped piece/board
    #use begin/rescue/else to return true/false in response to 
    #perform_move! succeeding - no error? true
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
      has_enemy?(jump)
    end
  end

  def jumping_row
    pos[0] + (color == :white ? -2 : 2)
  end
  
  def check_promotion
    self.king = true if pos[0] == (color == :white ? 0 : 7)
  end
  
  def has_enemy?(to_pos)
    pos = mid_pos(to_pos)
    !board.empty?(pos) && board[pos].color != self.color
  end

  def mid_pos(to_pos)
    mid_pos = []
    mid_pos[0] = (to_pos[0] + pos[0]) / 2
    mid_pos[1] = (to_pos[1] + pos[1]) / 2
    mid_pos
  end 
end