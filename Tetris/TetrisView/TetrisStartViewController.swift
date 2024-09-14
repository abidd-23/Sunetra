//
//  TetrisStartViewController.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 28/05/24.
//

import UIKit

class TetrisStartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func tetrisStartTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tetris", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "tetrisgame")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
}
