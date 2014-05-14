#encoding: utf-8

require 'pry'
require 'yaml'
require 'colorize'

require_relative 'board'
require_relative 'piece'

class Checkers

  attr_reader :board, :current_player, :players

  def intialize
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
    
    until over?
      @players[@current_player].play_turn(board)
      @current_player = (@current_player == :white ? :black : :white)
      #rescue from errors
    end
    
    puts 'Game Over Message'
    #tell who won and lost
  end

  private

  def over?
    #check player pieces.nil?
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
    to_pos = get_move("Where to?")
    
    board.move(from_pos, to_pos)

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
pry