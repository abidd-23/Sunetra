//
//  ProfileTableViewController.swift
//  Sunetra
//
//  Created by Batch-2 on 20/05/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var displayAge: Int = 0
    let userInfo = UserInfo.shared
    
    // Outlets for profile image and labels
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar title color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Configuring profile image view appearance
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3.0
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        // Fetch user profile details
        fetchUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfileDetails()
    }
    
    @objc func profileImageTapped(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Function to fetch user profile details from Firestore
    func fetchUserProfile() {
        guard let email = userInfo.email else {
            print("User email is missing")
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(email)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.userInfo.name = data?["name"] as? String ?? ""
                self.userInfo.gender = data?["gender"] as? String ?? ""
                self.userInfo.email = email
                self.displayAge = data?["age"] as? Int ?? 0
                if let profileImageUrl = data?["profileImageUrl"] as? String {
                    self.loadProfileImage(from: profileImageUrl)
                }
                
                // Update profile details after fetching data
                self.updateProfileDetails()
            } else {
                print("Document doesn't exist")
            }
        }
    }
    
    // Function to update profile details in the UI
    func updateProfileDetails() {
        nameLabel.text = userInfo.name
        emailLabel.text = userInfo.email
        genderLabel.text = userInfo.gender
        ageLabel.text = "\(displayAge)"
        
        if let profileImageUrl = userInfo.profileImageUrl {
            loadProfileImage(from: profileImageUrl)
        }
    }
    
    func loadProfileImage(from url: String){
        guard let storageUrl = URL(string: url), ["gs", "http", "https"].contains(storageUrl.scheme?.lowercased()) else {
            print("invalid url format")
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: url)
        
//        let localURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tempImage.jpg")
//        
//        storageRef.write(toFile: localURL){
//            url, error in
//            if let error  = error {
//                print("Error loading profile image \(error.localizedDescription)")
//                return
//            }
//            
//            if let url = url {
//                do{
//                    let data = try Data(contentsOf: url)
//                    self.imageView.image = UIImage(data: data)
//                }catch{
//                    print("Error in converting data \(error.localizedDescription)")
//                }
//            }
//        }
        storageRef.getData(maxSize: 10*1024*1024){
            data, error in
            if let error = error{
                print("Error loadding in profile image: \(error.localizedDescription)")
                return
            }
            if let data = data{
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    
    func uploadProfileImage(_ image: UIImage){
        guard let email = userInfo.email else {return}
        let storageRef = Storage.storage().reference().child("profileImages/\(email).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.75){
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storageRef.putData(imageData, metadata: metadata){
                metadata, error in
                if let error = error {
                    print("Error uploading image \(error.localizedDescription)")
                    return
                }
                storageRef.downloadURL{
                    url, error in
                    if let error = error{
                        print("Error getting download URL \(error.localizedDescription)")
                        return
                    }
                    guard let downloadUrl = url else {return}
                    self.updateUserProfileImageURL(downloadUrl.absoluteString)
                }
            }
        }
    }
    
    func updateUserProfileImageURL(_ url: String){
        guard let email = userInfo.email else {return}
        let db = Firestore.firestore()
        db.collection("users").document(email).updateData(["profileImageUrl": url]){
            error in
            if let error = error {
                print("Error updating profile Image \(error.localizedDescription)")
            }else{
                print("Profile image url updated successfully")
                
                self.userInfo.profileImageUrl = url
                self.loadProfileImage(from: url)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            uploadProfileImage(selectedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Checking if it's the first row of the first section
        if indexPath.section == 0 && indexPath.row == 0 {
            return 125
        } else {
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        } else {
            return 40.0
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.white
            headerView.contentView.backgroundColor = UIColor.clear
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if it's the first row of the third section
        if indexPath.section == 2 && indexPath.row == 0 {
            showCallEmailAlert()
        }
    }
    
    // Function to show alert for call and email options
    func showCallEmailAlert() {
        let alert = UIAlertController(title: "Contact Options", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { _ in
            if let phoneURL = URL(string: "tel://123456789"), UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Email", style: .default, handler: { _ in
            if let emailURL = URL(string: "mailto:sunetra@gmail.com"), UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
//        alert.view.superview?.subviews.first?.addGestureRecognizer(tapGesture)
        present(alert, animated: true, completion: nil)
    }
    
//    @objc func dismissAlert() {
//        dismiss(animated: true, completion: nil)
//    }
    
    // Action for the log out button tap
    @IBAction func signOutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            showLogoutSuccessAlert()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            showAlert(message: "Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    // To show a success alert after logout
    func showLogoutSuccessAlert() {
        let alert = UIAlertController(title: "Logout Successful", message: "You have been successfully logged out.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.redirectToLoginScreen()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // To redirect the user to the login screen
    func redirectToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: "login") as! loginViewController
        loginVC.modalPresentationStyle = .overFullScreen
        self.present(loginVC, animated: true, completion: nil)
    }

    // To show an alert with a given message
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Logout Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
