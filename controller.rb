require_relative 'model'
require_relative 'view'

class GameCycler
  attr_accessor :player_controller, :continue
  def initialize
    @continue = nil
  end

  def get_user_input
    @get_user_input ||= GetUserInput.new
  end

  def game_factory
    Game.new(get_user_input, player_controller)
  end

  def player_controller_factory
    PlayerController.new(get_user_input)
  end

  def start
    @player_controller = player_controller_factory
    until self.continue == 'no'
      game_factory.do_game
      self.continue = nil
      until self.continue == 'yes' || self.continue == 'no'
        self.continue = get_user_input.play_again
      end
    end
    Message::exit
  end
end

class Game
  attr_reader :ai, :player_controller, :get_user_input
  def initialize(get_user_input, player_controller)
    @get_user_input = get_user_input
    @player_controller = player_controller
    Message::greeting
  end

  def board
    @board ||= Board.new
  end

  def ai_factory(player_object, board)
    @ai = AI.new(player_object, board)
  end

  def place_mark(row, col, mark)
    board.spaces[row][col] = mark
  end

  def find_winner
    board.win_situations.each do |situation|
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

  def human_mark_action(player)
    mark_placement = get_user_input.get_mark_placement(board, player.name)
    row_col = get_user_input.word_to_cell_converter(mark_placement)
    place_mark(row_col[0], row_col[1], player.mark)
  end

  def computer_mark_action(player)
    mark_placement = ai.next_move
    puts "mark_placement = #{mark_placement}"
    place_mark(mark_placement[0], mark_placement[1], player.mark)
  end

  def win_check_logic(current_player)
    winner = find_winner
    if winner
      Display::board(board.spaces)
      Message::win(current_player.name, current_player.mark)
      return true
    elsif board.all_spaces_full?
      Display::board(board.spaces)
      Message::no_win
      return true
    end
    false
  end

  def game_flow(current_player)
    puts "board.spaces = #{board.spaces}"
    Display::board(board.spaces)
    if current_player.computer
      computer_mark_action(current_player)
    else
      human_mark_action(current_player)
    end
    return true if win_check_logic(current_player)
    false
  end

  def do_game
    ai_factory(player_controller.player2, board) if \
      player_controller.player2.computer
    current_player = player_controller.player2
    game_over = false
    until game_over
      if current_player == player_controller.player1
        current_player = player_controller.player2
      else
        current_player = player_controller.player1
      end
      game_over = game_flow(current_player)
    end
  end
end

class PlayerController
  attr_accessor :player1, :player2, :get_user_input
  def initialize(get_user_input)
    @get_user_input = get_user_input
    initialize_players
  end

  def player_factory(name, computer = false)
    Player.new(name, computer)
  end

  def initialize_human_player(player_number, mark = nil)
    player_object = player_factory(get_user_input.get_name(player_number))
    if player_number == 1
      player_object.mark = get_user_input.get_mark_choice(player_object.name)
    else
      player_object.mark = mark
    end
    player_object
  end

  def initialize_computer_player
    c_player_object = player_factory('Computer', true)
    c_player_object
  end

  def initialize_players
    @player1 = initialize_human_player(1)
    choice = get_user_input.play_person_or_computer
    if choice == 'human'
      @player2 = initialize_human_player(2, player1.opposite_mark_choice)
    else
      @player2 = initialize_computer_player
    end
    player2.mark = player1.opposite_mark_choice
  end
end

class GetUserInput
  def get_name(player_number)
    Prompt::get_name(player_number)
  end

  def play_again
    Prompt::play_again
  end

  def play_person_or_computer
    choice = nil
    until ['human', 'computer'].include?(choice)
      choice = Prompt::play_person_or_computer
    end
    choice
  end

  def get_mark_choice(name)
    choice = nil
    until (choice == 'X') || (choice == 'O')
      choice = Prompt::get_mark_choice(name)
    end
    choice
  end

  def get_mark_placement(board, player_name)
    choices = ['upper-left', 'upper-middle', 'upper-right', 'center-left', 
              'center-middle', 'center-right', 'lower-left', 'lower-middle', 
              'lower-right']
    mark_placement = nil
    until choices.include?(mark_placement)
      mark_placement = Prompt::get_mark_placement(choices, player_name)
      row_col = word_to_cell_converter(mark_placement)
      if choices.include?(mark_placement) && \
        board.mark_space_occupied?(row_col[0], row_col[1])
        mark_placement = nil
        Message::invalid_mark_placement
      end
    end
    mark_placement
  end

  def word_to_cell_converter(mark_placement)
    row = nil
    col = nil
    mark_placement.split('-').each do |n|
      case n
      when 'upper'
        row = 0
      when 'center'
        row = 1
      when 'lower'
        row = 2
      when 'left'
        col = 0
      when 'middle'
        col = 1
      when 'right'
        col = 2
      end
    end
    [row, col]
  end
end

class AI
  attr_accessor :computer_player, :board
  def initialize(computer_player, board)
    @computer_player = computer_player
    @board = board
  end

  # Finds opportunities to progress in making three marks in a row
  def find_opportunity(mark, opportunity_count)
    board.win_situations.each do |situation|
      opportunity = []
      situation.each do |cell|
        unless board.spaces[cell[0]][cell[1]] == mark
          opportunity << [cell[0], cell[1]]
        end
      end
      if (opportunity.count == opportunity_count) && \
        (board.mark_space_occupied?(opportunity[0][0], opportunity[0][1]) == \
          false)
        puts "opp = #{opportunity[0]}"
        return opportunity[0]
      end
    end
    nil
  end

  def find_opposite_corner_opportunity(mark)
    board.corners.each do |corner|
      if board.spaces[corner[0]][corner[1]] == mark
        opposite_corner = board.opposite_corner(corner[0], corner[1])
        if board.mark_space_occupied?(opposite_corner) == false
          return opposite_corner
        end
      end
    end
    nil
  end

  # Returns first free mark space on board when checking array of mark_spaces
  def mark_space_checker(mark_spaces)
    mark_spaces.each do |space|
      return space if board.spaces[space[0]][space[1]].empty?
    end
    nil
  end

  def opposing_mark
    if computer_player.mark == 'X'
      opposing_mark = 'O'
    else
      opposing_mark = 'X'
    end
    opposing_mark
  end

  # Returns next best space to place mark
  def next_move(first_move = false)
    win_opportunity = find_opportunity(computer_player.mark, 1)
    return win_opportunity unless win_opportunity.nil?
    block_opportunity = find_opportunity(computer_player.opposite_mark_choice, \
      1)
    return block_opportunity unless block_opportunity.nil?
    center_opportunity = mark_space_checker([board.center])
    return center_opportunity unless center_opportunity.nil?
    two_in_row_opportunity = find_opportunity(computer_player.mark, 2)
    return two_in_row_opportunity unless two_in_row_opportunity.nil?
    opp_corner_opportunity = find_opposite_corner_opportunity(\
      computer_player.opposite_mark_choice)
    return opp_corner_opportunity unless opp_corner_opportunity.nil?
    empty_corner = mark_space_checker(board.corners)
    return empty_corner unless empty_corner.nil?
    empty_side = mark_space_checker(board.sides)
    return empty_side unless empty_side.nil?
  end
end

# Game starter
GameCycler.new.start