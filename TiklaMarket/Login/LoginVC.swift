//
//  LoginVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 31.08.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class LoginVC: UIViewController {

   
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeHideKeyboard()
    }
    

    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailText.text, !email.isEmpty,
               let password = passwordText.text, !password.isEmpty else {
             makeAlert(titleInput: "Error", messageInput: "Username/Password")
             return
         }

         Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
             if let error = error {
                 self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
               print("hata")
                 
             } else {
                 self.performSegue(withIdentifier: "toMainVC", sender: nil)
                 
                 
                 print("Kullanıcı oturum açtı, UID: \(email)")
             }
         }
    }
    
    @IBAction func registerClicked(_ sender: Any) {
       
    }
    
    
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil )
    }
    
    
}
extension LoginVC {

    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))

        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }

    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
}
