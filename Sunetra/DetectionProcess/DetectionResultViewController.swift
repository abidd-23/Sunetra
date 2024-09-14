//
//  DetectionResultViewController.swift
//  Sunetra
//
//  Created by Anmol Ranjan on 29/05/24.
//

import UIKit
import CoreML

class DetectionResultViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var predictionLabel: UILabel!
    @IBOutlet var predictionPercentage: UILabel!
    @IBOutlet var messageTextLabel: UILabel!
    @IBOutlet var messageText2Label: UILabel!
    
    var image: UIImage?
    var prediction: ML_ModelOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            imageView?.image = image
            makePrediction(image: image)
        }
        DataController.shared.timeOfFirstDetection = Date() // Record time of first detection
        isModalInPresentation = true
    }

    func makePrediction(image: UIImage) {
        guard let pixelBuffer = image.pixelBuffer(width: 299, height: 299) else {
            print("Failed to convert image to pixel buffer")
            return
        }

        do {
            let model = try ML_Model(configuration: .init())
            let input = ML_ModelInput(image: pixelBuffer)
            
            prediction = try model.prediction(input: input)
            
            // Update UI with prediction results
            predictionLabel.text = prediction?.target
            if let targetClass = prediction?.target, let targetProbability = prediction?.targetProbability[targetClass] {
                let percentage = String(format: "%.1f%%", targetProbability * 100)
                predictionPercentage.text = percentage
                DataController.shared.addDetectionPercentage(targetProbability * 100)
                
                // Update message based on prediction
                if targetClass == "Strabismus" {
                    messageTextLabel.text = "This means one of your eyes shows signs of strabismus. But it's okay! Many kids have this, and there are ways to help."
                    messageText2Label.text = "Let's play some games that can help your eyes work together!"
                } else {
                    messageTextLabel.text = "Great news! Your eyes are working well together."
                    messageText2Label.text = "Let's try some fun exercises to keep them strong!"
                }
            } else {
                predictionPercentage.text = "Percentage not available"
            }
        } catch {
            print("Error making prediction: \(error)")
        }
    }
    
    // Navigating to Exercises i.e app's home screen
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "mainHome")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
}
