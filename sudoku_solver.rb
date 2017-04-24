#!/usr/bin/env ruby -w

require './sudoku_board.rb'
require './sudoku_cell.rb'

class SudokuSolver
  # Returns a new board object containing a solved board, or nil if no solved
  # board could be found.
  def solve(board)
    if board.solved?()
      puts "Solved board"
      return board
    else
      minRow, minColumn, minCandidateValues = board.findCellWithLeastCandidateValues()

      if minCandidateValues.size() < 1
        puts "No solution because there are no more candidates"
        return nil

      elsif minCandidateValues.size() == 1
        definiteValue = minCandidateValues[0]
        puts "R#{minRow}C#{minColumn} has to be #{definiteValue}"
        board.placeValue(minRow, minColumn, definiteValue)
        solve(board)

      else
        puts "R#{minRow}C#{minColumn} has the least number of candidates, " +
          "that is, #{minCandidateValues}"
        minCandidateValues.each do |candidate|
          puts "Guessing that R#{minRow}C#{minColumn} = #{candidate}"
          guessBoard = board.clone()
          guessBoard.placeValue(minRow, minColumn, candidate)
          puts guessBoard
          solution = solve(guessBoard)
          if solution != nil
            puts "No solution for guess R#{minRow}C#{minColumn} = #{candidate}"
            return solution
          end
        end
        # If we got here, it means that the board is not solvable
        puts "No solution because all guesses have been tried unsuccessfully"
        return nil
      end
    end
  end

end
