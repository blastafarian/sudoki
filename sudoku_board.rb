#!/usr/bin/env ruby -w

class SudokuBoard

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
    nil
  end

  # Returns true if and only if the Sudoku board is solved.
  def solved?()
    false
  end

  # Returns true if and only if the Sudoki board is in a valid state.
  def valid?()
    allRowsAreValid?() && allColsAreValid?() && allSquaresAreValid?()
  end

  def to_s()
    str = ""
    for row in 1..9 do
      for col in 1..9 do
        val = assignedValueOfCell(row, col)
        str += (val != nil) ? val.to_s() : "."
      end
      str += "\n"
    end
    str
  end

  ####################################
  # Private methods
  ####################################

  private

  def allRowsAreValid?()
    for row in 1..9 do
      rowVals = assignedValsOfRow(row)
      if hasDuplicates?(rowVals) || !(rowVals.each { |v| isValidCellValue?(v) })
        false
      end
    end
    true
  end

  def assignedValsOfRow(row)
    rowVals = []
    for col in 1..9 do
      cellVal = assignedValueOfCell(row, col)
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

  def allColsAreValid?()
    false
  end

  def allSquaresAreValid?()
    false
  end
end
