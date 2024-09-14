//
//  SecondCollectionViewCell.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 26/05/24.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell {
    
    // Outlets for UI elements
    @IBOutlet weak var gameIamgeLabel: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup initial UI configurations
        setupUI()
    }
    
    // Function to setup cell UI configurations
    private func setupUI() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: "#10445F")?.cgColor // You can change the color as needed
    }
}
