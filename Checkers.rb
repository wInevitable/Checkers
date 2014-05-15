#encoding: utf-8

require 'pry'
require 'yaml'
require 'colorize'

require_relative 'board'
require_relative 'piece'
require_relative 'invalid_move_error'

class Checkers

  attr_reader :players
  
  attr_accessor :current_player, :board

  def initialize
    @board = Board.new
    @players = {
      :white => HumanPlayer.new(:white),
      :black => HumanPlayer.new(:black)
    }
    @current_player = :white
  end

  def play
    puts "Quick, save the world from the radioactive wastes
    before they becomes a biohazard disaster and destroy the world!"
    puts "Recycle your way to Victory!"
    p @board
    until over?
      @players[@current_player].play_turn(board)
      @current_player = (@current_player == :white ? :black : :white)
      #rescue from errors
    end
    
    puts 'Game Over Message'
    puts "#{@players[@current_player]} has lost."
  end

  private

  def over?
    @board.board.flatten.compact.none? do |piece|
      piece.color == @current_player
    end
  end
end

class HumanPlayer

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    board.display
    
    if color == :white 
      puts "Recycler Message"
    else
      puts "Radioactive Message"
    end
    from_pos = get_move("Which Piece?")
    move_seq = get_move("Where to?")
    
    board[from_pos].perform_moves(move_seq)

    #implement save/load functionality
  end
  
  private

  def get_move(prompt)
    puts prompt
    gets.chomp
  end
end

g = Checkers.new
b = Board.new
b.display
#b[[2,1]].perform_moves([[3,0]])
pry