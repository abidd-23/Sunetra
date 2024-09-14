//
//  OnboardingStartViewController.swift
//  Sunetra
//
//  Created by Rohit Singh on 27/05/24.
//

import UIKit

class OnboardingStartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipButtonTapped(_ sender: UIBarButtonItem) {
        // Navigate to the personal details screen
        let storyboard = UIStoryboard(name: "Detection", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "personalDetails2")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
