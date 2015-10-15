require_relative 'model'
require_relative 'view'

class Game
  attr_accessor :player1, :player2, :continue
  def initialize
    Message::greeting
    initialize_players
    @continue = nil
  end

  def get_mark_choice(player)
    choice = nil
    until (choice == 'X') || (choice == 'O')
      choice = Prompt::get_mark_choice(player.name)
    end
    choice
  end

  def mark_space_occupied?(mark_placement)
    #
  end

  def get_mark_placement(player_name)
    choices = ['upper-left', 'upper-middle', 'upper-right', 'center-left', 
              'center-middle', 'center-right', 'lower-left', 'lower-middle', 
              'lower-right']
    mark_placement = nil
    until choices.include?(mark_placement)
      mark_placement = Prompt::get_mark_placement(choices, player_name)
      # insert mark checking here
    end
    mark_placement
  end

  def initialize_players
    @player1 = Player.new(Prompt::get_name(1))
    player1.mark = get_mark_choice(player1)
    @player2 = Player.new(Prompt::get_name(2))
    player2.mark = get_mark_choice(player2)
  end

  def start
    until self.continue == 'no'
      do_game
      self.continue = nil
      until self.continue == 'yes' || self.continue == 'no'
        self.continue = Prompt::play_again
      end
    end
    Message::exit
  end

  def game_flow(current_player, board)
    Display::board(board.spaces)
    mark_placement = get_mark_placement(current_player.name)
    board.place_mark(mark_placement, current_player.mark)
    winner = board.find_winner
    if winner
      Display::board(board.spaces)
      Message::win(current_player.name, current_player.mark)
      return true
    end
    false
  end

  def do_game
    board = Board.new
    current_player = player2
    game_over = false
    until game_over
      if current_player == player1
        current_player = player2
      else
        current_player = player1
      end
      game_over = game_flow(current_player, board)
    end
  end
end

# Game starter
game = Game.new
game.start