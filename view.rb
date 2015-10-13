module Display
  def self.board(board)
    print_space
    board.each do |row|
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

  def self.get_mark_choice(player_number)
    print "\nPlease enter player ##{player_number}'s mark (X or O): "
    gets.chomp.upcase
  end

  def self.get_mark_placement(choices)
    print "\nEnter where to place your mark (#{choices.join(", ")}): "
    gets.chomp.downcase
  end

  def self.play_again
    print "\nWould you like to play again?\n(Yes or No): "
    gets.chomp.downcase
end

module Messages
  def self.win(player_name, player_mark)
    print "\n#{player_name} (#{player_mark}) has won!"
  end

  def self.no_win
    print "\nIt's a draw! Nobody won."
  end
end