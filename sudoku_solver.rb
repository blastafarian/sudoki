#!/usr/bin/env ruby -w

require './sudoku_board.rb'
require './sudoku_cell.rb'

class SudokuSolver
  # Returns a new board object containing a solved board, or nil if no solved
  # board could be found.
  def solve(board)
    if board.solved?()
      return board.clone()
    else
      minRow, minColumn, minCell = board.findCellWithLeastCandidateValues()
      if minCell == nil || minCell.candidateValues.size() < 2
        return nil
      else
        minCell.candidateValues.each do |candidate|
          puts "Guessing that row #{minRow} and column #{minColumn} has value #{candidate}"
          guessBoard = board.clone()
          guessBoard.getCell(minRow, minColumn).definiteValue = candidate
          guessBoard.updateAfterCellGotDefiniteValue(minRow, minColumn)
          solution = solve(guessBoard)
          if solution != nil
            return solution
          end
        end
        # If we got here, it means that the board is not solvable
        return nil
      end
    end
  end

end
