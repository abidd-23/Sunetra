//
//  TetrominoHelper.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import Foundation
class TetrominoHelper : TetrominoHelperProtocol {
    func newRandomTetromino(_ startingRow: Int, _ startingColumn: Int) -> Tetromino{
        switch(Int.random(in: 1...7)){
        case 1:
            return LTetromino(startingRow, startingColumn)
        case 2:
            return LTetrominoInverted(startingRow, startingColumn)
        case 3:
            return SkewTetromino(startingRow, startingColumn)
        case 4:
            return SkewTetrominoInverted(startingRow, startingColumn)
        case 5:
            return TTetromino(startingRow, startingColumn)
        case 6:
            return StraightTetromino(startingRow, startingColumn)
        case 7:
            return SquareTetromino(startingRow, startingColumn)
        default:
            return StraightTetromino(startingRow, startingColumn)
        }
    }
}
