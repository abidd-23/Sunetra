//  FourthCollectionViewCell.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 01/06/24.
//

import UIKit

class FourthCollectionViewCell: UICollectionViewCell {
    
    // Using game data from DataController
    var usingGameData: [secondData] = DataController.shared.section2
    
    // Outlets for UI elements
    @IBOutlet weak var imageNameOutlet: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var timeLabelOutlet: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var resumeLabel: PaddedLabel!
    @IBOutlet weak var remainingPercentageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup initial UI configurations
        setupProgressView()
        setupUI()
        customizeLabel()
    }
    
    // Function to setup UI configurations
    private func setupUI() {
        self.layer.cornerRadius = 14
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor(hex: "#10445F")?.cgColor
    }
    
    // Function to setup progress view appearance
    private func setupProgressView(){
        progressView.progressTintColor = UIColor(hex: "#10445F")
        progressView.trackTintColor = UIColor(hex: "#E5E5E5")
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true

        // Transform to scale the progress view height
        let transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        progressView.transform = transform
    }
    
    // Function for customizing label appearance
    private func customizeLabel(){
        resumeLabel.layer.borderWidth = 1.0
    }
    
    // Function to configure progress view based on progress percentage
    func configure(progress: Float){
        // Setting the progress value
        progressView.setProgress(progress / 100, animated: true)
        
        // Updating the resumeLabel based on progress
        if progress < 100 {
            resumeLabel.text = "Resume"
            resumeLabel.backgroundColor = UIColor(hex: "#10445F")
            resumeLabel.layer.borderColor = UIColor(hex: "#10445F")?.cgColor
            resumeLabel.textColor = UIColor.white
        } else {
            resumeLabel.text = "Completed"
            resumeLabel.backgroundColor = UIColor.systemGray3
            resumeLabel.layer.borderColor = UIColor.systemGray3.cgColor
            resumeLabel.textColor = UIColor.systemGray
        }
    }
}
