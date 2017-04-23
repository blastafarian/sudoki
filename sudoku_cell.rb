#!/usr/bin/env ruby -w

require 'set'

class SudokuCell
  VALID_CELL_VALUES = (1..9).to_set()

  attr_accessor :row
  attr_accessor :column
  attr_accessor :candidateValues

  def initialize(row, column)
    @row = row
    @column = column
    @candidateValues = VALID_CELL_VALUES.clone()
    @placedValue = nil
  end

  def square()
    ((row - 1) / 3) * 3 + ((column - 1) / 3) + 1
  end

  def getPlacedValue()
    @placedValue
  end

  def setPlacedValue(placedValue)
    if @candidateValues.include?(placedValue)
      @placedValue = placedValue
      @candidateValues = Set.new().add(placedValue)
    else
      raise "Cannot place value #{placeValue} in cell R#{@row}C#{@column} because the the value is not one of the candidates: #{@candidateValues.to_a()}" 
    end
  end

end
