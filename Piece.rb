#encoding: utf-8
# unicode: http://unicode-table.com/en/sections/miscellaneous-symbols/
require_relative 'invalid_move_error'

class Piece

  #move to display method?
  DEATH = "☠"

  attr_reader :board, :color, :between

  attr_accessor :pos, :king

  def initialize(board, pos, color, king = false)
    raise 'invalid color' unless [:white, :black].include?(color)
    raise 'invalid pos' unless board.valid_pos?(pos)
    @board, @pos, @color, @king = board, pos, color, king
    self.board[pos] = self
  end

  def display
    if king
      color == :white ? "♼" : "☣"
    else
      color == :white ? "♽" : "☢"
    end
  end
  
  def perform_moves(seq)
    if valid_move_seq?(seq)
      old_pos = self.pos
      perform_moves!(seq, board)
      self.board[old_pos] = nil
      self.board[seq[-1]] = self
      check_promotion
    else
      raise InvalidMoveError.new("Enter a valid sequence.")
    end
  end

  def valid_move_seq?(seq)
    #calls perform_moves! on a duped piece/board
    #use begin/rescue/else to return true/false in response to 
    #perform_move! succeeding - no error? true
    begin
      piece_dup = self.dup
      piece_dup.perform_moves!(seq, board.dup)
    rescue InvalidMoveError => e
      false
    else
      true
    end
  end

  def perform_moves!(move_seq, move_board)
    #iterate through the array "move_seq"
    #execute one move at a time...
    if move_seq.count == 1
      single_move(self.pos, move_seq[0], move_board)
      self.pos = move_seq[0]
    else
      move_seq.each do |move|
        multi_move(self.pos, move, move_board)
        self.pos = move
      end
    end
  end

  def single_move(from_pos, to_pos, move_board)
    pos_moves = self.valid_moves(move_board) - self.jumping_moves
    if pos_moves.include?(to_pos)
      true
    else
      raise InvalidMoveError.new("Sequence is not valid.")
    end
  end
  
  def multi_move(from_pos, to_pos, move_board)
    pos_moves = self.valid_moves(move_board) - self.sliding_moves
    if pos_moves.include?(to_pos)
      true
    else
      raise InvalidMoveError.new("Sequence is not valid.")
    end

    #remove opponent
    move_board[mid_pos(to_pos)] = nil
  end

  #selects valid moves from all possible moves
  def valid_moves(temp_board)
    moves.select do |end_pos|
      temp_board.valid_pos?(end_pos) && temp_board.empty?(end_pos)
    end
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

  private

  #returns all possible moves
  def moves
    sliding_moves + jumping_moves
  end
  
  def sliding_row
    #black moves down, white moves up
    pos[0] + (color == :white ? -1 : 1)
  end
  
  def jumping_row
    pos[0] + (color == :white ? -2 : 2)
  end
  
  def check_promotion
    if pos[0] == 0 && color == :white && !self.king
      self.king = true
      puts "A Super Recycler has joined the fight!"
    elsif pos[0] == 7 && !self.king
      self.king = true
      puts "Another Biohazard has Emerged to Threaten Earth..."
    end
  end
  
  def has_enemy?(to_pos)
    pos = mid_pos(to_pos)
    if board.valid_pos?(to_pos)
      !board.empty?(pos) && board[pos].color != self.color
    end
  end

  def mid_pos(to_pos)
    mid_pos = []
    mid_pos[0] = (to_pos[0] + pos[0]) / 2
    mid_pos[1] = (to_pos[1] + pos[1]) / 2
    mid_pos
  end 
end