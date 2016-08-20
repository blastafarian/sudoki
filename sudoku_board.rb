#!/usr/bin/env ruby -w

require './sudoku_cell.rb'

require 'set'

class SudokuBoard

  ROWS = (1..9).to_set()
  COLUMNS = (1..9).to_set()
  SQUARES = (1..9).to_set()
  VALID_VALUES = (1..9).to_set()

  def initialize
    @board = []
    ROWS.each do |row|
      @board[row] = []
      COLUMNS.each do |column|
        @board[row][column] = SudokuCell.new()
      end
    end
  end                      

  def cell(row, column)
    @board[row][column]
  end

  # From the set of cells that don't yet have a definite value, finds the cell
  # with the least number of candidate values. If there are multiple such
  # cells, returns any one of them. If there are no such cells, returns nil.
  def findCellWithLeastCandidateValues()
    return nil
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
        val = cell(row, column).definiteValue()
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
      cellVal = cell(row, column).definiteValue()
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
    COLUMNS.map { |column| cell(row, column).definiteValue() }.to_set() == VALID_VALUES
  end

  def completeColumn?(column)
    ROWS.map { |row| cell(row, column).definiteValue() }.to_set() == VALID_VALUES
  end

  def completeSquare?(square)
    true
  end
end
