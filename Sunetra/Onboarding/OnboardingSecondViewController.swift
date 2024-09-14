//
//  OnboardingSecondViewController.swift
//  Sunetra
//
//  Created by Anmol Ranjan on 30/05/24.
//

import UIKit

class OnboardingSecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func skipButtonTapped(_ sender: UIBarButtonItem) {
        // Navigating to the personal details screen
        let storyboard = UIStoryboard(name: "Detection", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "personalDetails2")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}
