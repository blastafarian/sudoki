#!/usr/bin/env ruby -w

require 'set'

class SudokuCell
  VALID_CELL_VALUES = (1..9).to_set()

  attr_accessor :candidateValues

  def initialize(value = nil)
    @candidateValues = VALID_CELL_VALUES
  end

  def definiteValue()
    if @candidateValues != nil && @candidateValues.size() == 1
      return @candidateValues.to_a().first()
    else
      return nil
    end
  end

  def definiteValue=(value)
    if VALID_CELL_VALUES.include?(value.to_i())
      @candidateValues = Set.new().add(value.to_i())
    else
      raise "Attempted to assign invalid value #{value} to a cell"
    end
  end
end
