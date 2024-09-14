//
//  OnboardingFinalViewController.swift
//  Sunetra
//
//  Created by Rohit Singh on 27/05/24.
//

import UIKit

class OnboardingFinalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func letstartButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Detection", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "personalDetails2")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}
