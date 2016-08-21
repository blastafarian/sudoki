#!/usr/bin/env ruby -w

require './sudoku_board.rb'

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

    if number.to_i() >= 1 && number.to_i() <= 9
      board.getCell(row, column).definiteValue = number
    else
      syserr.puts("Input file contains invalid number '#{number}'")
    end
  end
end

puts board
puts "Valid: #{board.valid?}"
puts "Solved: #{board.solved?}"
