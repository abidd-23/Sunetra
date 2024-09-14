//
//  PersonalDetailsViewController.swift
//  Sunetra
//
//  Created by Anmol Ranjan on 29/05/24.
//

import UIKit
import FirebaseFirestore

class PersonalDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let personalDetailsCells = ["NameCell", "GenderCell", "DobCell", "GlassesCell"]
    var userInfo = UserInfo.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register custom cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NameCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GenderCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DobCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GlassesCell")
        
        // Configure the date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        continueButton.isEnabled = false
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalDetailsCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = personalDetailsCells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            let textField = UITextField(frame: CGRect(x: cell.contentView.frame.width / 2, y: 0, width: cell.contentView.frame.width / 2 - 15, height: cell.contentView.frame.height))
            textField.placeholder = "Enter your name"
            textField.text = userInfo.name
            textField.textAlignment = .right
            textField.delegate = self
            textField.tag = 1000
            cell.contentView.addSubview(textField)
            textField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)

        case 1:
//            cell.textLabel?.text = "Gender: \(userInfo.gender)"
            
            cell.textLabel?.text = "Gender"
            let genderLabel = UILabel(frame: CGRect(x: cell.contentView.frame.width / 2, y: 0, width: cell.contentView.frame.width / 2 - 15, height: cell.contentView.frame.height))
            genderLabel.text = userInfo.gender
            genderLabel.textAlignment = .right
            cell.contentView.addSubview(genderLabel)
        case 2:
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .medium
//            cell.textLabel?.text = "Date of Birth: \(dateFormatter.string(from: userInfo.dob))"
            
            cell.textLabel?.text = "Date of Birth"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            let dobLabel = UILabel(frame: CGRect(x: cell.contentView.frame.width / 2, y: 0, width: cell.contentView.frame.width / 2 - 15, height: cell.contentView.frame.height))
            dobLabel.text = dateFormatter.string(from: userInfo.dob)
            dobLabel.textAlignment = .right
            cell.contentView.addSubview(dobLabel)
        case 3:
            let switchControl = UISwitch()
            switchControl.isOn = userInfo.glasses
            switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchControl
            cell.textLabel?.text = "Wears Glasses"
            cell.selectionStyle = .none
        default:
            break
        }
        
        return cell
    }
    
    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        if let name = textField.text, !name.isEmpty {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        userInfo.dob = sender.date
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }

    @objc func switchChanged(_ sender: UISwitch) {
        userInfo.glasses = sender.isOn
    }
    
    // Handle Name Text Field Changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1000 {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            userInfo.name = updatedText
        }
        return true
    }
    
    // Dismiss Keyboard on Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let nameTextField = textField.viewWithTag(1000) as? UITextField,
           let name = nameTextField.text, !name.isEmpty {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            presentGenderPicker()
        case 2:
            datePicker.isHidden = false
        default:
            datePicker.isHidden = true
            break
        }
    }
    
    func presentGenderPicker() {
        let alert = UIAlertController(title: "Select Gender", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Male", style: .default, handler: { _ in
            self.userInfo.gender = "Male"
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }))
        alert.addAction(UIAlertAction(title: "Female", style: .default, handler: { _ in
            self.userInfo.gender = "Female"
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        Task { @MainActor in
            print("User Info: \(userInfo)")
            
            let userDetails : [String:Any] = [
                "name" : userInfo.name,
                "gender" : userInfo.gender,
                "age" : userInfo.age,
                "glasses" : userInfo.glasses,
                "profileImageUrl" : userInfo.profileImageUrl ?? ""
            ]
            
            guard let email = userInfo.email else{
                print("user email is missing")
                return
            }
            
            let db = Firestore.firestore()
            
            do{
                try await db.collection("users").document(email).setData(userDetails)
                print("Data written successfully")
                let storyboard = UIStoryboard(name: "Detection", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "detectionAvatar")
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true)
            }catch{
                print("error in writing data: \(error.localizedDescription)")
            }
           
        }
    }
}
