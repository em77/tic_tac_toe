require_relative 'model'
require_relative 'view'

class Game
  attr_accessor :player1, :player2, :continue, :board
  def initialize
    Message::greeting
    initialize_players
    start
    @continue = 'yes'
  end

  def get_mark_choice(player_number)
    choice = nil
    until (choice == 'X') || (choice == 'O')
      Prompt::get_mark_choice(player_number)
    end
  end

  def initialize_players
    @player1 = Player.new(Prompt::get_name(1), get_mark_choice(1))
    @player2 = Player.new(Prompt::get_name(2), get_mark_choice(2))
  end

  def start
    until continue == 'no'
      do_game
    end
  end

  def do_game
    @board = Board.new
  end
end