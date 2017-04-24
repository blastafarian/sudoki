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
        @board[row][column] = SudokuCell.new(row, column)
      end
    end
  end                      

  def clone
    newBoard = SudokuBoard.new()
    ROWS.each do |row|
      COLUMNS.each do |column|
        newBoard.setCell(row, column, getCell(row, column).clone())
      end
    end
    return newBoard
  end

  def setCellPlacedValue(row, column, placedValue)
    getCell(row, column).setPlacedValue(placedValue)

    # Update candidates in row
    COLUMNS.each do |c|
      if c != column
        getCell(row, c).candidateValues().delete(placedValue)
      end
    end

    # Update candidates in column
    ROWS.each do |r|
      if r != row
        getCell(r, column).candidateValues().delete(placedValue)
      end
    end

    getCellsOfSquare(getCell(row, column).square).each do |cell|
      if ! (cell.row == row and cell.column == column)
        cell.candidateValues().delete(placedValue)
      end
    end
  end

  def setCell(row, column, cell)
    @board[row][column] = cell
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
  # the details (row number, column number and array of candidate values) of
  # he cell that has the minimum number of candidate values. If there are
  # multiple such cells, returns the details of any one of them. If there are
  # no such cells, returns nil, nil and nil.
  def findCellWithLeastCandidateValues()
    minRow, minColumn, minCandidateValues = nil, nil, nil
    ROWS.each do |row|
      COLUMNS.each do |column|
        cell = getCell(row, column)
        if getCell(row, column).candidateValues().size() > 1
          if (minCandidateValues == nil ||
             cell.candidateValues().size() < minCandidateValues.size())
            minRow = row
            minColumn = column
            minCandidateValues = cell.candidateValues()
          end
        end
      end
    end
    return minRow, minColumn, minCandidateValues.to_a()
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
        val = getCell(row, column).getPlacedValue()
        str += (val != nil)? val.to_s() : "."
      end
      str += "|\n"
    end
    str += "+---+---+---+\n"
    str += "Valid: #{valid?}\n"
    str += "Solved: #{solved?}\n"
    str += "Candidates:\n"
    ROWS.each do |row|
      COLUMNS.each do |column|
        cell = getCell(row, column)
        str += "R#{row}C#{column}: #{cell.candidateValues.to_a()}\n"
      end
    end
    return str
  end

  ####################################
  # Private methods
  ####################################

  private

  def completeRow?(row)
    valuesOfRow = COLUMNS.map { |column| getCell(row, column) }.
      select { |cell| cell.getPlacedValue() }.
      map { |cell| cell.getPlacedValue() }

    valuesOfRow.to_set() == VALID_CELL_VALUES
  end

  def completeColumn?(column)
    valuesOfColumn = ROWS.map { |row| getCell(row, column) }.
      select { |cell| cell.getPlacedValue() }.
      map { |cell| cell.getPlacedValue() }

    valuesOfColumn.to_set() == VALID_CELL_VALUES
  end

  def completeSquare?(square)
    valuesOfSquare = getCellsOfSquare(square).
      select { |cell| cell.getPlacedValue() }.
      map { |cell| cell.getPlacedValue() }

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
      select { |cell| cell.getPlacedValue() }.
      map { |cell| cell.getPlacedValue() }

    (! arrayHasDuplicates?(valuesOfRow)) && valuesOfRow.to_set().subset?(VALID_CELL_VALUES)
  end

  def validColumn?(column)
    valuesOfColumn = ROWS.map { |row| getCell(row, column) }.
      select { |cell| cell.getPlacedValue() }.
      map { |cell| cell.getPlacedValue() }

    (! arrayHasDuplicates?(valuesOfColumn)) && valuesOfColumn.to_set().subset?(VALID_CELL_VALUES)
  end

  def validSquare?(square)
    valuesOfSquare = getCellsOfSquare(square).
      select { |cell| cell.getPlacedValue() }.
      map { |cell| cell.getPlacedValue() }

    (! arrayHasDuplicates?(valuesOfSquare)) && valuesOfSquare.to_set().subset?(VALID_CELL_VALUES)
  end

  def arrayHasDuplicates?(array)
    array != nil && array.uniq().length() < array.length()
  end
end
