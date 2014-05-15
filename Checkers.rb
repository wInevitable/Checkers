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
    puts "Quick! Save the world from the radioactive wastes" +
    " before they become a biohazard disaster and destroy the world!"
    puts "Recycle your way to Victory or Doom Us All!"

    until over?
      begin
        @players[@current_player].play_turn(self)
      rescue IOError, InvalidMoveError => e
        puts e.message
        retry
      end
      
      switch_turns
    end
    
    board.display
    if @current_player == :white
      puts "Holder of the White Pieces, "
      puts "You have failed Planet Earth!"
      puts "We shall all perish at the hands of the Waste."
    else
      puts "Victory! Planet Earth shall endure."
      puts "Let the Biohazards be banished to the darkness!"
    end
  end

  def switch_turns
    if @current_player == :white
      @current_player = :black
    else
      @current_player = :white
    end
  end
  
  def save(filename)
    File.open(filename, 'w') do |f|
      f.puts to_yaml
    end
  end
  
  def self.load(filename)
    YAML::load_file(filename)
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

  def play_turn(game) #needs to be refactored
    game.board.display
    
    if color == :white 
      puts "Recycler, you must act fast! Doom is approaching."
    else
      puts "Spread your disease at your own peril, Black Knight."
    end
    begin
      from_pos = get_move("Which Piece Would You Like To Move?")
      move_seq = get_move("Please Enter A Move Sequence: B6, A5")

      if from_pos[0] == 'save'
        game.save(move_seq[0])
        return play_turn(game)
      else
        coords = parse(from_pos, move_seq)
      end
    
      if game.board[coords[0]].nil?
        raise IOError.new("Please select an actual piece.")
      end

      if game.board[coords[0]].color == game.current_player
        game.board[coords.shift].perform_moves(coords)
      else
        raise IOError.new("You can only control your own pieces.")
      end
    rescue IOError, InvalidMoveError => e
      puts e.message
      game.board.display
      retry
    end
  end
  
  private

  def get_move(prompt)
    puts prompt
    gets.chomp.split(",")
  end
  
  def parse(from, to)
      coords = [from, to]
      coords.flatten.map do |cor|
        unless /[a-h][1-8]/ === cor
          raise IOError.new("Enter Coordinates between A0-H8 OR
          save and 'filename'")
        end
        [8 - cor[1].to_i, ('a'..'h').to_a.index(cor[0])]
      end
   end
end

g = Checkers.new
pry