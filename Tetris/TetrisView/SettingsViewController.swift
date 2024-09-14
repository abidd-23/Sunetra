//
//  SettingsViewController.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let defaults = UserDefaults.standard

    @IBOutlet var audioSwicth: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func audioSwitchValueChanged(_ sender: UISwitch) {
        defaults.set(audioSwicth.isOn, forKey: StoreKeys.audioIsEnabled)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
