#!/usr/bin/env ruby -w

require './sudoku_board.rb'

board = SudokuBoard.new()
IO.readlines("./sample_board_01.txt").each_with_index do |line, index|
  row = index + 1
  for column in 1..9 do
    board.cell(row, column).definiteValue = line[column-1]
  end
end

puts "The board has these contents:"
puts board

puts "Is the board valid? #{board.valid?}"
puts "Is the board solved? #{board.solved?}"
