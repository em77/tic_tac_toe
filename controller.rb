require_relative 'model'
require_relative 'view'

class Game
  attr_accessor :player1, :player2, :continue, :board, :game_over, :turn
  def initialize
    Message::greeting
    initialize_players
    @continue = 'yes'
    @game_over = false
    @turn = player1
  end

  def get_mark_choice(player_number)
    choice = nil
    until (choice == 'X') || (choice == 'O')
      Prompt::get_mark_choice(player_number)
    end
  end

  def get_mark_placement(player_name)
    choices = ['upper-left', 'upper-middle', 'upper-right', 'center-left', 
              'center-middle', 'center-right', 'lower-left', 'lower-middle', 
              'lower-right']
    mark_placement = nil
    until choices.include?(mark_placement)
      mark_placement = Display::get_mark_placement(choices, player_name)
    end
    mark_placement
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

  def game_flow(current_player)
    Display::board
    mark_placement = get_mark_placement(current_player.name)
    board.place_mark(mark_placement, current_player.mark)
    winner = board.find_winner
    Message::win(current_player.name, current_player.mark) if winner
  end

  def do_game
    @board = Board.new
    until game_over
      game_flow(turn)
      if turn == player1
        turn = player2
      else
        turn = player1
      end
    end
  end
end