//
//  FirstCollectionViewCell.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 26/05/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class FirstCollectionViewCell: UICollectionViewCell {
    
    // Outlets for UI elements
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var totalTimeAllGameOutlet: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupProgressView()
        updateDateLabel()
        updateTotalTimeLabel()
        setupUserNameLabel()
        fetchUserName()
    }
    
    // Function to setup cell UI configurations
    private func setupUI(){
        self.layer.cornerRadius = 14
        self.layer.masksToBounds = true
    }
    
    // Function to update date labels
    private func updateDateLabel(){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        dayLabel.text = formatter.string(from: Date())
        
        formatter.dateFormat = "MMMM, yyyy"
        monthLabel.text = formatter.string(from: Date())
    }
    
    // Function to setup progress view appearance
    private func setupProgressView(){
        progressView.progressTintColor = UIColor(hex: "#10445F")
        progressView.trackTintColor = UIColor(hex: "#10445F")?.withAlphaComponent(0.3)
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        
        // Adjust the y-scale for thickness of progress view
        let transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        progressView.transform = transform
    }
    
    // Function to update total time label
    func updateTotalTimeLabel(){
        let totalTime = DataController.shared.totalGameTime()
        totalTimeAllGameOutlet.text = "\(totalTime) mins"
    }
    
    // Function to setup initial state of user name label
    private func setupUserNameLabel(){
        userNameLabel.alpha = 0
    }
    
    // Function to fetch user name from Firestore
    func fetchUserName(){
        guard let email = UserInfo.shared.email else {
            print("User email is missing")
            return
        }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(email)
        
        docRef.getDocument{(document, error) in
            if let document = document, document.exists{
                let data = document.data()
                let name = data?["name"] as? String ?? " "
                DispatchQueue.main.async {
                    self.userNameLabel.text = name
                }
            }else{
                print("Document doesn't exist")
            }
        }
        // Fade in animation for user name label
        UIView.animate(withDuration: 0.5){
            self.userNameLabel.alpha = 1
        }
    }
}
