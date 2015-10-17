require_relative 'model'
require_relative 'view'

class Game
  attr_accessor :player1, :player2, :continue
  def initialize
    Message::greeting
    initialize_players
    @continue = nil
  end

  def win
    [
      [ [0, 0], [0, 1], [0, 2] ],
      [ [0, 1], [1, 1], [2, 1] ],
      [ [2, 0], [2, 1], [2, 2] ],
      [ [0, 0], [1, 0], [2, 0] ],
      [ [1, 0], [1, 1], [1, 2] ],
      [ [0, 2], [1, 2], [2, 2] ],
      [ [0, 0], [1, 1], [2, 2] ],
      [ [0, 2], [1, 1], [2, 0] ]
    ]
  end

  def find_winner(board)
    win.each do |situation|
      x_mark_count = 0
      o_mark_count = 0
      situation.each do |cell|
        x_mark_count += 1 if board.spaces[cell[0]][cell[1]] == 'X'
        o_mark_count += 1 if board.spaces[cell[0]][cell[1]] == 'O'
      end
      return 'X' if x_mark_count == 3
      return 'O' if o_mark_count == 3
      x_mark_count = 0
      o_mark_count = 0
    end
    nil
  end

  def get_mark_choice(player)
    choice = nil
    until (choice == 'X') || (choice == 'O')
      choice = Prompt::get_mark_choice(player.name)
    end
    choice
  end

  def mark_space_occupied?(mark_placement, board)
    row_cell = board.word_to_cell_converter(mark_placement)
    if board.spaces[row_cell[0]][row_cell[1]].empty?
      return false
    else
      Message::invalid_mark_placement
      return true
    end
  end

  def get_mark_placement(player_name, board)
    choices = ['upper-left', 'upper-middle', 'upper-right', 'center-left', 
              'center-middle', 'center-right', 'lower-left', 'lower-middle', 
              'lower-right']
    mark_placement = nil
    space_occupied = nil
    until choices.include?(mark_placement)
      mark_placement = Prompt::get_mark_placement(choices, player_name)
      mark_placement = nil if mark_space_occupied?(mark_placement, board)
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
    mark_placement = get_mark_placement(current_player.name, board)
    board.place_mark(mark_placement, current_player.mark)
    winner = find_winner(board)
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