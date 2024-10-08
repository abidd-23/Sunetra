//
//  BoardService.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import Foundation
import SwiftUI

class BoardService : BoardServiceProtocol{
    var board: Board?
    var tetrominoStartingColumn: Int = 0
    var tetrominoStartingRow: Int = 0
    
    func initBoardMap(rows: Int, columns: Int){
        board = Board(rows: rows, columns: columns)
        declareTetrominoStartPosition()
    }
    
    func clearBoard() {
        for i in 0...(board!.rowNumber - 1){
            clearRow(i)
        }
    }
    
    private func declareTetrominoStartPosition(){
        tetrominoStartingRow = 0
        tetrominoStartingColumn = Int(floor(Double(board!.columnNumber / 2)))
    }
    
    private func clearTetrominoInBoard(_ squares: TetrominoSquares){
        updateTetrominoSquares(squares, boardPositionFill: nil)
    }
    
    func setNewTetrominoInBoard(squares: TetrominoSquares, color: UIColor?) -> Bool {
        return moveTetromino(original: nil, desired: squares, color: color)
    }
    
    private func updateTetrominoSquares(_ squares: TetrominoSquares, boardPositionFill: UIColor?){
        board!.map[squares.firstSquare.row][squares.firstSquare.column] = boardPositionFill
        board!.map[squares.secondSquare.row][squares.secondSquare.column] = boardPositionFill
        board!.map[squares.thirdSquare.row][squares.thirdSquare.column] = boardPositionFill
        board!.map[squares.fourthSquare.row][squares.fourthSquare.column] = boardPositionFill
    }
    
    @discardableResult
    func moveTetromino(original: TetrominoSquares?, desired: TetrominoSquares, color: UIColor?) -> Bool{
        if tetrominoIsInCorrectPlace(original: original, desired: desired){
            if original != nil{
                clearTetrominoInBoard(original!)
            }
            updateTetrominoSquares(desired, boardPositionFill: color)
            return true
        }
        return false
    }
    
    private func tetrominoIsInCorrectPlace(original: TetrominoSquares?, desired: TetrominoSquares) -> Bool {
        if !tetrominoSquareIsAvailable(original, desired.firstSquare){
            return false
        }
        if !tetrominoSquareIsAvailable(original, desired.secondSquare) {
            return false
        }
        if !tetrominoSquareIsAvailable(original, desired.thirdSquare){
            return false
        }
        if !tetrominoSquareIsAvailable(original, desired.fourthSquare){
            return false
        }
        return true
    }
    
    private func tetrominoSquareIsAvailable(_ originalSquares: TetrominoSquares?, _ desiredSquare: Square) -> Bool {
         if desiredSquare.row < 0 || desiredSquare.column < 0 {
            return false
        }
        if desiredSquare.row > (board!.rowNumber - 1) || desiredSquare.column > (board!.columnNumber - 1){
            return false
        }
        if !desiredSquareIsFromOriginalTetromino(originalSquares, desiredSquare) && board!.map[desiredSquare.row][desiredSquare.column] != nil {
            return false
        }
        return true
    }
    
    private func desiredSquareIsFromOriginalTetromino(_ originalSquares: TetrominoSquares?, _ desiredSquare: Square) -> Bool{
        if originalSquares == nil{
            return false
        }
        
        let originalSquaresArray = [originalSquares!.firstSquare, originalSquares!.secondSquare, originalSquares!.thirdSquare, originalSquares!.fourthSquare]
        for originalSquare in originalSquaresArray{
            if originalSquare.row == desiredSquare.row && originalSquare.column == desiredSquare.column {
                return true
            }
        }
        return false
    }
    
    func clearFullRows(_ squares: TetrominoSquares) -> Int {
        var rowsCleared = 0
        for row in tetrominoRowsFromUpToDown(squares) {
            if rowIsFull(row) {
                clearRowAndDescendAboveSquares(row)
                rowsCleared += 1
            }
        }
        return rowsCleared
    }
    
    private func tetrominoRowsFromUpToDown(_ squares: TetrominoSquares) -> Array<Int>{
        var rows: Array<Int> = []
        rows.append(squares.firstSquare.row)
        if !rows.contains(squares.secondSquare.row){
            rows.append(squares.secondSquare.row)
        }
        if !rows.contains(squares.thirdSquare.row){
            rows.append(squares.thirdSquare.row)
        }
        if !rows.contains(squares.fourthSquare.row){
            rows.append(squares.fourthSquare.row)
        }
        rows.sort()
        return rows
    }
    
    private func rowIsFull(_ row: Int) -> Bool {
        for i in 0...(board!.columnNumber - 1){
            if board!.map[row][i] == nil {
                return false
            }
        }
        return true
    }
    
    private func clearRowAndDescendAboveSquares(_ row: Int){
        clearRow(row)
        let firstRowToDescend = row - 1
        for rowIndex in (0...firstRowToDescend).reversed(){
            for columnIndex in 0...(board!.columnNumber - 1){
                if board!.map[rowIndex][columnIndex] != nil{
                    board!.map[rowIndex + 1][columnIndex] = board!.map[rowIndex][columnIndex]
                    board!.map[rowIndex][columnIndex] = nil
                }
            }
        }
    }
    
    private func clearRow(_ row: Int){
        for i in 0...(board!.columnNumber - 1){
            board!.map[row][i] = nil
        }
    }
}
