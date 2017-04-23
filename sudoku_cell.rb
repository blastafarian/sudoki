#!/usr/bin/env ruby -w

require 'set'

class SudokuCell
  VALID_CELL_VALUES = (1..9).to_set()

  attr_accessor :row
  attr_accessor :column
  attr_accessor :candidateValues
  attr_accessor :placedValue

  def initialize(row, column)
    @row = row
    @column = column
    @candidateValues = VALID_CELL_VALUES.clone()
  end

  def square()
    ((row - 1) / 3) * 3 + ((column - 1) / 3) + 1
  end

  def placedValue=(placedValue)
    if @candidateValues.include?(placedValue)
      @placedValue = placedValue
      @candidateValues.select{ |c| c == placedValue }
    else
      raise "Cannot place value #{placeValue} in cell R#{@row}C#{@column} because the the value is not one of the candidates: #{@candidateValues.to_a()}" 
    end
  end

end
