//
//  WeeklyDetectionResultViewController.swift
//  MLInt
//
//  Created by Anmol Ranjan on 03/06/24.
//

import UIKit

class WeeklyDetectionResultViewController: UIViewController {

    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var predictionPercentage1: UILabel!
    @IBOutlet var imageView0: UIImageView!
    @IBOutlet var predictionPercentage0: UILabel!
    @IBOutlet var messegeLabel: UILabel!
    
    var image: UIImage? // Image used for prediction
    var prediction: ML_Model_v2Output?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isModalInPresentation = true
    }
    
    func setupUI() {
        // Display first detection result
        imageView0?.image = DataController.shared.detectionImages[0]
        let previousPrediction = String(format: "Confidence: %.1f%%", DataController.shared.detectionPercentages[0])
        predictionPercentage0.text = previousPrediction
        if let image = image {
            makePrediction(image: image)
        }
        
        // Display second detection result if available, otherwise make prediction
        if DataController.shared.detectionPercentages.indices.contains(1) {
            let imageAvailable = DataController.shared.detectionImages[1]
            imageView1?.image = imageAvailable
        }
    }
    
    func makePrediction(image: UIImage) {
        guard let pixelBuffer = image.pixelBuffer(width: 299, height: 299) else {
            print("Failed to create pixel buffer")
            return
        }

        do {
            let model = try ML_Model_v2(configuration: .init())
            let input = ML_Model_v2Input(image: pixelBuffer)
            prediction = try model.prediction(input: input)
            
            // Updating UI with prediction results
            if let targetClass = prediction?.target, let targetProbability = prediction?.targetProbability[targetClass] {
                let percentage = String(format: "%.1f%%", targetProbability * 100)
                predictionPercentage1.text = "Confidence: \(percentage)"
                
                DataController.shared.addDetectionPercentage(targetProbability * 100)
                
                // customizing the messege according to percentage values
                if targetProbability * 100 < DataController.shared.detectionPercentages[0] {
                    messegeLabel.text = "Keep It Up! Your pupil response is showing noticeable improvement!"
                } else {
                    messegeLabel.text = "Stay motivated! Keep playing games to continue working on your vision."
                }
            } else {
                predictionPercentage0.text = "Percentage not available"
                predictionPercentage1.text = "Percentage not available"
            }
        } catch {
            print("Error making prediction: \(error)")
        }
    }
}
