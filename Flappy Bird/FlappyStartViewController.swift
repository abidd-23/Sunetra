//
//  FlappyStartViewController.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 28/05/24.
//

import UIKit

class FlappyStartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func flappyStartTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "FlappyBird", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "flappybird")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
    }
    
}
