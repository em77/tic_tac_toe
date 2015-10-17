class Board
  attr_accessor :spaces
  def initialize
    @spaces = [['', '', ''],
              ['', '', ''],
              ['', '', '']]
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

  def place_mark(mark_placement, mark)
    row_cell = word_to_cell_converter(mark_placement)
    spaces[row_cell[0]][row_cell[1]] = mark
  end
end

class Player
  attr_accessor :name, :mark
  def initialize(name)
    @name = name
    @mark = mark
  end
end