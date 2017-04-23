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
      minRow, minColumn, minCell = board.findCellWithLeastCandidateValues()
      puts "Cell with row #{minRow} and column #{minColumn} has the least number of candidates. Candidates are: #{minCell.candidateValues().to_a()}"
      if minCell == nil || minCell.candidateValues.size() < 1
        return nil
      else
        minCell.candidateValues.each do |candidate|
          puts "Guessing that row #{minRow} and column #{minColumn} has value #{candidate}"
          guessBoard = board.clone()
          guessBoard.getCell(minRow, minColumn).placedValue = candidate
          puts(guessBoard)
          solution = solve(guessBoard)
          if solution != nil
            puts "Guess that row #{minRow} and column #{minColumn} has value #{candidate} failed"
            return solution
          end
        end
        # If we got here, it means that the board is not solvable
        puts "No solution"
        return nil
      end
    end
  end

end
