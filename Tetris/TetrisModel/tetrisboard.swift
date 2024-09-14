//
//  tetrisboard.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import Foundation
import SwiftUI

struct Board{
    var rowNumber = 0
    var columnNumber = 0
    var map = [[UIColor?]]()
    
    init(rows: Int,
         columns: Int){
        rowNumber = rows
        columnNumber = columns
        map = Array(repeating: Array(repeating: nil, count: columnNumber), count: rows)
    }
}
