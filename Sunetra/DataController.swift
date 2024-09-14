//
//  DataController.swift
//  Sunetra
//
//  Created by Rohit Singh on 31/05/24.
//

import UIKit

class DataController{
    static let shared = DataController()
    private init(){}
    
    // user images for detection
    var detectionImages: [UIImage] = []
    
    // Function to add images to the detectionImages array
    func addDetectionImage(_ image: UIImage) {
        detectionImages.append(image)
    }
    
    // user percentages for detection
    var detectionPercentages: [Double] = []
    
    // Function to append percentages to the detectionPercentages array
    func addDetectionPercentage(_ percent: Double) {
        detectionPercentages.append(percent)
    }
    
    // games data
    var section2:[secondData] = [
        secondData(game: "Flappy Bird", timing: 10, imageName: "img1.png", storyboardName: "FlappyBird", progress: 0.0, remainingPercentage: 100.0),
        secondData(game: "Tetris", timing: 14, imageName: "img2.png", storyboardName: "Tetris", progress: 0.0, remainingPercentage: 100.0),
        secondData(game: "Ball Tracking", timing: 6, imageName: "img3.png", storyboardName: "BallTracking", progress: 0.0, remainingPercentage: 100.0)
    ]
    
    // Function to calculate total game time
    func totalGameTime() -> Int {
        return section2.reduce(0){ $0 + $1.timing }
    }
    
    // Function to calculate total game progress
    func totalGameProgress() -> Float {
        return section2.reduce(0){ $0 + $1.progress }
    }
    
    // Function to update game progress
    func updateGameProgress(gameName: String, progress: Float) {
        if let index = section2.firstIndex(where: { $0.game == gameName }) {
            section2[index].progress += progress
            section2[index].remainingPercentage -= progress
            // to handle progress more than 100
            if section2[index].progress >= 100 {
                section2[index].progress = 100
            }
            // to handle remaining percentage less than 0
            if section2[index].remainingPercentage < 0 {
                section2[index].remainingPercentage = 0
            }
        }
    }
    
    // week details
    var weekDataPass: [weekData] = [
    weekData(week: "Week 1", weekDetails: "3 Exercises | 3.5 Hrs"),
    weekData(week: "Week 2", weekDetails: "3 Exercises | 4 Hrs"),
    weekData(week: "Week 3", weekDetails: "3 Exercises | 3.5 Hrs"),
    weekData(week: "Week 4", weekDetails: "3 Exercises | 3 Hrs")
    ]
    
    // variable for time of first detection
    var timeOfFirstDetection = Date()
    
    //faq data
    var faqData: [cellData] = [
        cellData(opened: false, title: "What is Strabismus?", sectionData: ["Strabismus, also known as crossed eyes or squint, is a condition where the eyes don't align properly, causing one or both eyes to turn inwards, outwards, upwards, or downwards."]),
        cellData(opened: false, title: "How does your app help with strabismus?", sectionData: ["Our app provides exercises and techniques to help train the eyes to align properly, aiding in the management of strabismus."]),
        cellData(opened: false, title: "Is this app a substitute for professional medical advice?", sectionData: ["No, our app is not a substitute for professional medical advice. It is intended to complement the guidance of an eye care specialist or ophthalmologist."]),
        cellData(opened: false, title: "Who can use this app?", sectionData: ["Our app is designed for individuals diagnosed with strabismus who are looking for additional support in managing their condition."]),
        cellData(opened: false, title: "How frequently should I use the app?", sectionData: ["The frequency of app usage may vary depending on individual needs and recommendations from your eye care specialist. Generally, regular and consistent practice is beneficial for seeing improvement."]),
        cellData(opened: false, title: "Are the exercises safe?", sectionData: ["Yes, the exercises provided in our app are safe when performed correctly. However, it's important to consult with your eye care specialist before starting any new exercises, especially if you have any underlying eye conditions."]),
        cellData(opened: false, title: "Can children use this app?", sectionData: ["While the exercises in our app are generally safe for children, it's important for parents or guardians to supervise their usage, and to consult with a pediatric ophthalmologist for personalized advice."]),
        cellData(opened: false, title: "How long does it take to see results?", sectionData: ["Results may vary depending on the severity of the condition and individual factors. Consistent practice over time is key to seeing improvement."])
    ]

}
