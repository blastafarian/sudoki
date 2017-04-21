#!/usr/bin/env ruby -w

require './sudoku_cell.rb'

require 'set'

class SudokuBoard

  ROWS = (1..9).to_set()
  COLUMNS = (1..9).to_set()
  SQUARES = (1..9).to_set()
  VALID_CELL_VALUES = (1..9).to_set()

  def initialize
    @board = []
    ROWS.each do |row|
      @board[row] = []
      COLUMNS.each do |column|
        @board[row][column] = SudokuCell.new()
      end
    end
  end                      

  def clone
    newBoard = SudokuBoard.new()
    ROWS.each do |row|
      COLUMNS.each do |column|
        cell = newBoard.getCell(row, column)
	cell.candidateValues = @board[row][column].candidateValues
      end
    end
    return newBoard
  end

  def updateAfterCellGotDefiniteValue(row, column)
    defVal = getCell(row, column).definiteValue()
    ROWS.each do |r|
      COLUMNS.each do |c|
        if ! (r == row and c == column)
	  getCell(r, c).candidateValues().delete(defVal)
	end
      end
    end
  end

  def getCell(row, column)
    if ! ROWS.include?(row)
      raise "Invalid row number: #{row}"
    elsif ! COLUMNS.include?(column)
      raise "Invalid column number: #{column}"
    else
      @board[row][column]
    end
  end

  # From the set of cells that have more than one candidate values, returns
  # the details (row number, column number and SudokuCell object) of the cell
  # that has the minimum number of candidate values. If there are multiple such
  # cells, returns the details of any one of them. If there are no such cells,
  # returns nil, nil and nil.
  def findCellWithLeastCandidateValues()
    minRow, minColumn, minCellObject = nil, nil, nil
    ROWS.each do |row|
      COLUMNS.each do |column|
        if @board[row][column].candidateValues().size() > 1
	  if (minCellObject == nil) ||
	     (@board[row][column].candidateValues().size() < minCellObject.candidateValues().size())
	    minRow, minColumn, minCellObject = row, column, @board[row][column]
	  end
	end
      end
    end
    return minRow, minColumn, minCellObject
  end

  # Returns true if and only if the Sudoku board is solved.
  def solved?()
    ROWS.all? { |row| completeRow?(row) } &&
      COLUMNS.all? { |column| completeColumn?(column) } &&
      SQUARES.all? { |square| completeSquare?(square) }
  end

  # Returns true if and only if the Sudoku board is in a valid state.
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
        val = getCell(row, column).definiteValue()
        str += (val != nil)? val.to_s() : "."
      end
      str += "|\n"
    end
    str += "+---+---+---+\n"
    str += "Valid: #{valid?}\n"
    str += "Solved: #{solved?}\n"
    minRow, minColumn, minCellObject = findCellWithLeastCandidateValues()
    if minCellObject != nil
      str += "The cell with the minimum number of candidate values is at row #{minRow} and column #{minColumn}. That cell has #{minCellObject.candidateValues().size()} candidate values: #{minCellObject.candidateValues().to_a()}"
    end
    return str
  end

  ####################################
  # Private methods
  ####################################

  private

  def completeRow?(row)
    valuesOfRow = COLUMNS.map { |column| getCell(row, column) }.
      select { |cell| cell.hasDefiniteValue?() }.
      map { |cell| cell.definiteValue() }

    valuesOfRow.to_set() == VALID_CELL_VALUES
  end

  def completeColumn?(column)
    valuesOfColumn = ROWS.map { |row| getCell(row, column) }.
      select { |cell| cell.hasDefiniteValue?() }.
      map { |cell| cell.definiteValue() }

    valuesOfColumn.to_set() == VALID_CELL_VALUES
  end

  def completeSquare?(square)
    valuesOfSquare = getCellsOfSquare(square).
      select { |cell| cell.hasDefiniteValue?() }.
      map { |cell| cell.definiteValue() }

    valuesOfSquare.to_set() == VALID_CELL_VALUES
  end

  # Returns a set of all the cells of the given square
  def getCellsOfSquare(square)
    retval = Set.new()
    row_of_top_left_cell = (3 * ((square - 1) / 3)) + 1
    column_of_top_left_cell = (3 * ((square - 1) % 3)) + 1
    for column_offset in 0..2 do
      for row_offset in 0..2 do
        row = row_of_top_left_cell + row_offset
        column = column_of_top_left_cell + column_offset
        retval.add(getCell(row, column))
      end
    end
    retval
  end

  def validRow?(row)
    valuesOfRow = COLUMNS.map { |column| getCell(row, column) }.
      select { |cell| cell.hasDefiniteValue?() }.
      map { |cell| cell.definiteValue() }

    (! arrayHasDuplicates?(valuesOfRow)) && valuesOfRow.to_set().subset?(VALID_CELL_VALUES)
  end

  def validColumn?(column)
    valuesOfColumn = ROWS.map { |row| getCell(row, column) }.
      select { |cell| cell.hasDefiniteValue?() }.
      map { |cell| cell.definiteValue() }

    (! arrayHasDuplicates?(valuesOfColumn)) && valuesOfColumn.to_set().subset?(VALID_CELL_VALUES)
  end

  def validSquare?(square)
    valuesOfSquare = getCellsOfSquare(square).
      select { |cell| cell.hasDefiniteValue?() }.
      map { |cell| cell.definiteValue() }

    (! arrayHasDuplicates?(valuesOfSquare)) && valuesOfSquare.to_set().subset?(VALID_CELL_VALUES)
  end

  def arrayHasDuplicates?(array)
    array != nil && array.uniq().length() < array.length()
  end
end
