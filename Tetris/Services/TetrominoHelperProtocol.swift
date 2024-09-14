//
//  TetrominoHelperProtocol.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import Foundation
protocol TetrominoHelperProtocol{
    func newRandomTetromino(_ startingRow: Int, _ startingColumn: Int) -> Tetromino
}
