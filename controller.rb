require_relative 'model'
require_relative 'view'

class Game
  attr_accessor :player1, :player2, :continue, :board, :ai
  def initialize
    Message::greeting
    @continue = nil
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

  def get_mark_choice(player)
    choice = nil
    until (choice == 'X') || (choice == 'O')
      choice = Prompt::get_mark_choice(player.name)
    end
    choice
  end

  def get_mark_placement(player_name)
    choices = ['upper-left', 'upper-middle', 'upper-right', 'center-left', 
              'center-middle', 'center-right', 'lower-left', 'lower-middle', 
              'lower-right']
    mark_placement = nil
    until choices.include?(mark_placement)
      mark_placement = Prompt::get_mark_placement(choices, player_name)
      row_cell = board.word_to_cell_converter(mark_placement)
      if choices.include?(mark_placement) && \
        board.mark_space_occupied?(row_cell)
        mark_placement = nil
        Message::invalid_mark_placement
      end
    end
    mark_placement
  end

  def initialize_players
    @player1 = Player.new(Prompt::get_name(1))
    player1.mark = get_mark_choice(player1)
    choice = nil
    until ['human', 'computer'].include?(choice)
      choice = Prompt::play_person_or_computer
    end
    if choice == 'human'
      @player2 = Player.new(Prompt::get_name(2))
    else
      @player2 = Player.new('Computer', true)
    end
    player2.mark = board.opposite_mark_choice(player1.mark)
  end

  def game_flow(current_player)
    puts "board.spaces = #{board.spaces}"
    Display::board(board.spaces)
    if current_player.computer
      mark_placement = ai.next_move
      puts "mark_placement = #{mark_placement}"
      board.place_mark(mark_placement, current_player.mark)
    else
      mark_placement = get_mark_placement(current_player.name)
      row_cell = board.word_to_cell_converter(mark_placement)
      board.place_mark(row_cell, current_player.mark)
    end
    winner = find_winner
    if winner
      Display::board(board.spaces)
      Message::win(current_player.name, current_player.mark)
      return true
    end
    false
  end

  def do_game
    @board = Board.new
    initialize_players
    @ai = AI.new(player2, board) if player2.computer
    current_player = player2
    game_over = false
    until game_over
      if current_player == player1
        current_player = player2
      else
        current_player = player1
      end
      game_over = game_flow(current_player)
    end
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
        (board.mark_space_occupied?(opportunity[0]) == false)
        puts "opp = #{opportunity[0]}"
        return opportunity[0]
      end
    end
    nil
  end

  def find_opposite_corner_opportunity(mark)
    board.corners.each do |corner|
      if board.spaces[corner[0]][corner[1]] == mark
        return board.opposite_corner(corner)
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
    block_opportunity = find_opportunity(board.opposite_mark_choice(\
      computer_player.mark), 1)
    return block_opportunity unless block_opportunity.nil?
    center_opportunity = mark_space_checker([board.center])
    return center_opportunity unless center_opportunity.nil?
    opp_corner_opportunity = find_opposite_corner_opportunity(\
      board.opposite_mark_choice(computer_player.mark))
    return opp_corner_opportunity unless opp_corner_opportunity.nil?
    empty_corner = mark_space_checker(board.corners)
    return empty_corner unless empty_corner.nil?
    empty_side = mark_space_checker(board.sides)
    return empty_side unless empty_side.nil?
  end
end

# Game starter
game = Game.new
game.start