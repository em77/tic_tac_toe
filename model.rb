class Board
  attr_accessor :spaces
  def initialize
    @spaces = [['', '', ''],
              ['', '', ''],
              ['', '', '']]
  end

  def win_situations
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

  def corners
    [
      [0,0], [0,2], [2,0], [2,2]
    ]
  end

  def center
    [1,1]
  end

  def sides
    [
      [0,1], [1,2], [2,1], [1,0]
    ]
  end

  def opposite_corner(row, col)
    row_col = [row,col]
    case row_col
    when [0,0]
      return [2,2]
    when [2,2]
      return [0,0]
    when [2,0]
      return [0,2]
    when [0,2]
      return [2,0]
    end
    nil   
  end

  def all_spaces_full?
    return true unless spaces.flatten.any? {|col| col == ''}
  end

  def mark_space_occupied?(row, col)
    if spaces[row][col].empty?
      return false
    else
      return true
    end
  end
end

class Player
  attr_accessor :name, :mark, :computer
  def initialize(name, computer = false)
    @name = name
    @mark = mark
    @computer = computer
  end

  def opposite_mark_choice
    if mark == 'X'
      return 'O'
    else
      return 'X'
    end
  end
end