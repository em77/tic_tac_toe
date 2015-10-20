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

  def opposite_corner(corner)
    case corner
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

  def word_to_cell_converter(mark_placement)
    row = nil
    cell = nil
    mark_placement.split('-').each do |n|
      case n
      when 'upper'
        row = 0
      when 'center'
        row = 1
      when 'lower'
        row = 2
      when 'left'
        cell = 0
      when 'middle'
        cell = 1
      when 'right'
        cell = 2
      end
    end
    [row, cell]
  end

  def opposite_mark_choice(mark)
    if mark == 'X'
      return 'O'
    else
      return 'X'
    end
  end

  def mark_space_occupied?(mark_placement)
    if spaces[mark_placement[0]][mark_placement[1]].empty?
      return false
    else
      return true
    end
  end

  def place_mark(mark_placement, mark)
    spaces[mark_placement[0]][mark_placement[1]] = mark
  end
end

class Player
  attr_accessor :name, :mark, :computer
  def initialize(name, computer = false)
    @name = name
    @mark = mark
    @computer = computer
  end
end