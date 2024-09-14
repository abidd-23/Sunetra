//
//  BoardServiceProtocol.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import Foundation
import UIKit

protocol BoardServiceProtocol{
    var board: Board? { get }
    var tetrominoStartingColumn: Int { get }
    var tetrominoStartingRow: Int { get }
    
    func initBoardMap(rows: Int, columns: Int)
    func setNewTetrominoInBoard(squares: TetrominoSquares, color: UIColor?) -> Bool
    func moveTetromino(original: TetrominoSquares?, desired: TetrominoSquares, color: UIColor?) -> Bool
    func clearFullRows(_ squares: TetrominoSquares) -> Int
    func clearBoard()
}
