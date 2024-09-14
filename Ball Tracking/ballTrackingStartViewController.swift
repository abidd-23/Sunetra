//
//  ballTrackingStartViewController.swift
//  Sunetra
//
//  Created by Abid Ali    on 29/05/24.
//

import UIKit

class ballTrackingStartViewController: UIViewController {

    
    @IBOutlet weak var ballStartButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setPortraitOrientation()
        }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setPortraitOrientation() {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }

        override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
            return .portrait
        }

        override var shouldAutorotate: Bool {
            return true
        }
    
   
    @IBAction func ballStartButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "BallTracking", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "balls")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    

}
