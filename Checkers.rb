#encoding: utf-8

require 'pry'
require 'yaml'

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
    until over?
      #take turns
    end
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
  
  def get_move
    
  end
end

g = Checkers.new
pry