//
//  signUpViewController.swift
//  Sunetra
//
//  Created by Abid Ali    on 22/05/24.
//

import UIKit
import Firebase
import GoogleSignIn //for google sign in
import AuthenticationServices // for apple sign in

class signUpViewController: UIViewController, UITextFieldDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    

    // Outlets for email and password text fields
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // Outlets for Google and Apple sign-up views
    @IBOutlet weak var google: UIView!
//    @IBOutlet weak var apple: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.delegate = self
        
        // background color of Google and Apple sign-up views
        if let hexColor = UIColor(hex: "#F3F2F7") {
            google?.backgroundColor = hexColor
//            apple?.backgroundColor = hexColor
        }
        google?.layer.masksToBounds = true
//        apple?.layer.masksToBounds = true
        
        
//        set up apple and google sign up tap gestures
        let googleTapGesture = UITapGestureRecognizer(target: self, action: #selector(googleSignInTapped))
        google.addGestureRecognizer(googleTapGesture)
        
//        let appleTapGesture = UITapGestureRecognizer(target: self, action: #selector(appleSignInTapped))
//        apple.addGestureRecognizer(appleTapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        google?.layer.cornerRadius = google.frame.height / 2
//        apple?.layer.cornerRadius = apple.frame.height / 2
    }
    
//    // Function triggered when Apple sign-in view is tapped
//    @objc func appleSignInTapped(){
//        let provider = ASAuthorizationAppleIDProvider()
//        let request = provider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//    
//    
//    // Function to handle successful Apple sign-in authorization
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential{
//            let email = appleIdCredential.email
//            
//            UserInfo.shared.email = email
//            
//            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
//            let vc = storyboard.instantiateViewController(identifier: "onBoarding")
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true)
//        }
//    }
//    
//    
//    // Function to handle Apple sign-in authorization errors
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
//        print("apple signin error \(error.localizedDescription)")
//    }
//    
    
    // Function triggered when Google sign-in view is tapped
    @objc func googleSignInTapped(){
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let signInConfig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: self){
            signInResult, error in
            if let error = error{
                self.showAlert(message: error.localizedDescription)
                return
            }
            guard let user = signInResult?.user else {return}
            let idToken = user.idToken?.tokenString
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken!, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential){
                authResult, error in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                    return
                }
                
                UserInfo.shared.email = authResult?.user.email
                
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "onBoarding")
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    // Dismiss the keyboard when the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return password.resignFirstResponder()
    }
    
    // Dismiss the keyboard when the user taps outside the text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    // Function triggered when Sign Up button is tapped
    @IBAction func signUpTapped(_ sender: UIButton) {
        guard let email = email.text, !email.isEmpty else {
            showAlert(message: "Please enter your email.")
            return
        }
        guard let password = password.text, !password.isEmpty else {
            showAlert(message: "Please enter your password.")
            return
        }
        guard password.count >= 8 else {
            showAlert(message: "Your password is too short. Password should be at least 8 characters.")
            return
        }
        
        // Creating a new user with Firebase authentication
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            if let error = error as NSError? {
                        if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                            switch errorCode {
                            case .emailAlreadyInUse:
                                self.showAlert(message: "The email address is already in use.")
                            case .invalidEmail:
                                self.showAlert(message: "The email address is not valid.")
                            case .weakPassword:
                                self.showAlert(message: "The password is too weak.")
                            default:
                                self.showAlert(message: "Error: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        UserInfo.shared.email = email
                        
                        // Navigating to the onboarding screen
                        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "onBoarding")
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                    }
        }
    }
    
    // Action for the "Already have an account?" button
    @IBAction func alreadyAccount(_ sender: Any) {
        // Navigating to the login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    // Function to show an alert with a given message
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Sign Up Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
