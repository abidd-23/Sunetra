//
//  DataModelExercises.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 26/05/24.
//

import UIKit

// struct for games details
struct secondData{
    var game: String
    var timing: Int
    var imageName: String
    var storyboardName: String
    var progress: Float
    var remainingPercentage: Float
}

// struct for weekly tracking
struct weekData{
    var week: String
    var weekDetails: String
}

// Struct to hold data for each cell in the table view
struct cellData{
    var opened = Bool()
    var title = String()
    var sectionData = [String]() // Data for the section (answers to FAQs)
}
