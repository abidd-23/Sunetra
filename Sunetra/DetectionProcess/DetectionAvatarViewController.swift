//  DetectionAvatarViewController.swift
//  Sunetra
//
//  Created by Anmol Ranjan on 12/06/24.
//

import UIKit

class DetectionAvatarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startDetectionButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Disclaimer",
            message: "\nThe results from this detection tool are for informational purposes only and may not be 100% accurate. Please consult a professional for a definitive diagnosis.\n",
            preferredStyle: .alert
        )
        
        let continueAction = UIAlertAction(title: "Continue", style: .default) { _ in
            self.performSegue(withIdentifier: "segueToInstructions", sender: self)
        }
        
        alertController.addAction(continueAction)
        present(alertController, animated: true, completion: nil)
    }
}

/* messeges
"The results from this detection tool are for informational purposes only and may not be 100% accurate. Please consult a professional for a definitive diagnosis."
 "This detection is powered by machine learning and may not be 100% accurate. Please consult a professional for a definitive diagnosis."
*/
