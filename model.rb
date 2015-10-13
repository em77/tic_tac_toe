class Board
  attr_accessor :spaces
  def initialize
    @spaces = [['', '', ''],
              ['', '', ''],
              ['', '', '']]
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

  def find_winner
    win.each do |situation|
      x_mark_count = 0
      o_mark_count = 0
      situation.each do |cell|
        x_mark_count += 1 if spaces[cell[0]][cell[1]] == 'X'
        o_mark_count += 1 if spaces[cell[0]][cell[1]] == 'O'
      end
      return 'X' if x_mark_count == 3
      return 'O' if o_mark_count == 3
    end
    nil
  end
end

class Player
  attr_accessor :name, :mark
  def initialize(name, mark)
    @name = name
    @mark = mark
  end
end