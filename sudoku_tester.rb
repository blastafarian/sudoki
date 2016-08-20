#!/usr/bin/env ruby -w

require './sudoku_board.rb'

b = SudokuBoard.new()

puts "The board has these contents:"
puts b

puts "Is the board solved? #{b.solved?}"
puts "Is the board valid? #{b.valid?}"
