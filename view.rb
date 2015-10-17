module Display
  def self.board(board_spaces)
    print_space
    board_spaces.each do |row|
      print_row = ""
      row.each do |cell|
        cell = " " if cell.empty?
        print_row << "|_#{cell}_"
      end
      print "#{print_row}|\n".rjust(32)
    end
    print_space
  end

  def self.print_space
    print "\n\n"
  end
end

module Prompt
  def self.get_name(player_number)
    print "\nPlease enter player ##{player_number}'s name: "
    gets.chomp
  end

  def self.get_mark_choice(player_name)
    print "\nPlease enter #{player_name}'s mark (X or O): "
    gets.chomp.upcase
  end

  def self.get_mark_placement(choices, player_name)
    print "\n#{player_name}, enter where to place your mark \n(#{choices.join(", "
      )}): "
    gets.chomp.downcase
  end

  def self.play_again
    print "\nWould you like to play again?\n(Yes or No): "
    gets.chomp.downcase
  end
end

module Message
  def self.greeting
    puts "\nWelcome to Tic-Tac-Toe, a game for those of strong will"
  end

  def self.win(player_name, player_mark)
    print "\n#{player_name} (#{player_mark}) has won!"
  end

  def self.no_win
    print "\nIt's a draw! Nobody won."
  end

  def self.invalid_mark_placement
    print "\nERROR: There is already a mark in that space.\n\n"
  end

  def self.exit
    print "\nThank you for playing!\n\n"
  end
end