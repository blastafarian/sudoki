#!/usr/bin/env ruby -w

require 'set'

class SudokuBoard

  ROWS = (1..9).to_set()
  COLUMNS = (1..9).to_set()
  SQUARES = (1..9).to_set()
  VALID_VALUES = (1..9).to_set()

  def initialize
    @possibleValues = []
    @possibleValues[0] = [[1], [2], [3], [4], [5], [6], [7], [8], [9]]
    @possibleValues[3] = [[4], [5], [6], [7], [8], [9], [1], [2], [3]]
    @possibleValues[6] = [[7], [8], [9], [1], [2], [3], [4], [5], [6]]
    @possibleValues[1] = [[2], [3], [4], [5], [6], [7], [8], [9], [1]]
    @possibleValues[4] = [[5], [6], [7], [8], [9], [1], [2], [3], [4]]
    @possibleValues[7] = [[8], [9], [1], [2], [3], [4], [5], [6], [7]]
    @possibleValues[2] = [[3], [4], [5], [6], [7], [8], [9], [1], [2]]
    @possibleValues[5] = [[6], [7], [8], [9], [1], [2], [3], [4], [5]]
    @possibleValues[8] = [[9], [1], [2], [3], [4], [5], [6], [7], [8]]
  end                      

  # Assigns the given value to the cell that is at the given row and column.
  # Returns nil.
  def assignValueToCell(row, col, value)
    @possibleValues[row, col] = [value]
  end

  # Returns the value that has been assigned to a cell, or nil if no value
  # has been assigned.
  def assignedValueOfCell(row, col)
    poss = possibleValuesOfCell(row, col)
    if poss != nil && poss.length() == 1
      poss.first()
    else
      nil
    end
  end

  # Returns a collection of the possible values that could be assigned to a
  # cell, or nil if there are no possible values.
  def possibleValuesOfCell(row, col)
    @possibleValues[row-1][col-1]
  end

  # Finds an unassigned cell with the minimum number of possible values.
  # Returns:
  #   - (row, col, possibleValues) if such a cell exists, where row is a number
  #     from 1 to 9, cell is a number from 1 to 9 and possibleValues is a set
  #     of numbers from 1 to 9.
  #   - nil otherwise.
  def findCellWithMinPossibleValues
    return nil
  end

  # Returns true if and only if the Sudoku board is solved.
  def solved?()
    ROWS.all? { |row| completeRow?(row) } &&
      COLUMNS.all? { |column| completeColumn?(column) } &&
      SQUARES.all? { |square| completeSquare?(square) }
  end

  # Returns true if and only if the Sudoki board is in a valid state.
  def valid?()
    ROWS.all? { |row| validRow?(row) } &&
      COLUMNS.all? { |column| validColumn?(column) } &&
      SQUARES.all? { |square| validSquare?(square) }
  end

  def to_s()
    str = ""
    ROWS.each do |row|
      str += "+---+---+---+\n" if row % 3 == 1
      COLUMNS.each do |column|
        str += "|" if column % 3 == 1
        val = assignedValueOfCell(row, column)
        str += (val != nil)? val.to_s() : "."
      end
      str += "|\n"
    end
    str += "+---+---+---+"
    return str
  end

  ####################################
  # Private methods
  ####################################

  private

  def validRow?(row)
    rowVals = assignedValsOfRow(row)
    return !hasDuplicates?(rowVals) &&
      rowVals.all? { |v| isValidCellValue?(v) }
  end

  def assignedValsOfRow(row)
    rowVals = []
    COLUMNS.map do |column|
      cellVal = assignedValueOfCell(row, column)
      if cellVal != nil
        rowVals.push(cellVal)
      end
    end
    return rowVals
  end

  def hasDuplicates?(array)
    array != nil && array.uniq().length() < array.length()
  end

  def isValidCellValue?(val)
    val >= 1 && val <= 9
  end

  def validColumn?(column)
    true
  end

  def validSquare?(square)
    true
  end

  def completeRow?(row)
    Set.new(COLUMNS.map { |column| assignedValueOfCell(row, column) }) == VALID_VALUES
  end

  def completeColumn?(column)
    Set.new(ROWS.map { |row| assignedValueOfCell(row, column) }) == VALID_VALUES
  end

  def completeSquare?(square)
    true
  end
end
