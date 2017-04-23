#!/usr/bin/env ruby -w

require './sudoku_board.rb'
require './sudoku_solver.rb'

def usage
  puts "sudoku_tester.rb INPUT_FILE"
end

if ARGV.size() != 1
  usage()
  exit(1)
end

input_file = ARGV[0]

board = SudokuBoard.new()
IO.readlines(input_file).each_with_index do |line, index|
  row = index + 1
  for column in 1..9 do
    character = line[column - 1]
    if character == "."
      next
    end

    begin
      number = character.to_i()
    rescue
      syserr.puts("Input file contains invalid character '#{character}'")
      exit 1
    end

    if number >= 1 && number <= 9
      board.setCellPlacedValue(row, column, number)
    else
      syserr.puts("Input file contains invalid number '#{number}'")
    end
  end
end

puts board

if !board.solved?()
  puts "Solving board ..."
  solvedBoard = SudokuSolver.new().solve(board)
  puts solvedBoard
end
