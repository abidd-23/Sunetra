//
//  loginViewController.swift
//  Sunetra
//
//  Created by Abid Ali    on 22/05/24.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices
class loginViewController: UIViewController, UITextFieldDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
    

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
//    @IBOutlet weak var appleLogin: UIView!
    @IBOutlet weak var googleLogin: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.delegate = self
        if let hexColor = UIColor(hex: "#F3F2F7") {
            googleLogin?.backgroundColor = hexColor
//            appleLogin?.backgroundColor = hexColor
        }
        googleLogin?.layer.masksToBounds = true
//        appleLogin?.layer.masksToBounds = true
//        var abid = 1
        
        // Set up Google and Apple log-in tap gestures
        let googleTapGesture = UITapGestureRecognizer(target: self, action: #selector(googleLoginTapped))
        googleLogin.addGestureRecognizer(googleTapGesture)
        
//        let appleTapGesture = UITapGestureRecognizer(target: self, action: #selector(appleLoginTapped))
//        appleLogin.addGestureRecognizer(appleTapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Set the corner radius to half of the view's height to make it a capsule shape
        googleLogin?.layer.cornerRadius = googleLogin.frame.height / 2
//        appleLogin?.layer.cornerRadius = appleLogin.frame.height / 2
    }
    
    
    // Function triggered when Apple log-in view is tapped
//    @objc func appleLoginTapped(){
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
//    // Function to handle successful Apple log-in authorization
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential
//        {
//            let email = appleIdCredential.email
//            
//            UserInfo.shared.email = email
//            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                       let vc = storyboard.instantiateViewController(withIdentifier: "mainHome")
//                       vc.modalPresentationStyle = .overFullScreen
//                       self.present(vc, animated: true)
//        }
//    }
    
    
//    // Function to handle Apple log-in authorization errors
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
//        print("apple login error \(error.localizedDescription)")
//    }
//    
    
    // Function triggered when Google log-in view is tapped
    @objc func googleLoginTapped(){
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let signInConfig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(withPresenting: self){
            signinResult, error in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            guard let user = signinResult?.user else {return}
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
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "mainHome")
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return password.resignFirstResponder()
    }
    
    // Dismiss keyboard when touching outside of text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = email.text, !email.isEmpty else {
            showAlert(message: "Please enter your email.")
            return
        }
        guard let password = password.text, !password.isEmpty else {
            showAlert(message: "Please enter your password.")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
                    if let error = error as NSError? {
                        print("Firebase error code: \(error.code)")
                        // Handling Firebase authentication errors
                        if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                            switch errorCode {
                            case .networkError:
                                self.showAlert(message: "Network error. Please try again.")
                            case .userNotFound:
                                self.showAlert(message: "Account not found. Please sign up.")
                            case .wrongPassword:
                                self.showAlert(message: "Incorrect password. Please try again.")
                            case .invalidEmail:
                                self.showAlert(message: "Invalid email format. Please check your email.")
                            default:
                                self.showAlert(message: "Incorrect Username or Password")
                        }
                    } else {
                        self.showAlert(message: "Unknown error occurred: \(error.localizedDescription)")
                    }
                } else {
                    UserInfo.shared.email = email
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "mainHome")
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    
    @IBAction func noAccount(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "signUp")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

struct GitHUbUser{
var name: String
 var bio: String
}
