//
//  RegisterVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 31.08.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
class RegisterVC: UIViewController {
    
    @IBOutlet weak var countryText: UITextField!
  
    @IBOutlet weak var passwordText: UITextField!
  
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
  
    @IBOutlet weak var phoneText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeHideKeyboard()
        
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toCreateUser", sender: nil)
                }
            }
        }else{
          makeAlert(titleInput: "Error", messageInput: "Userename/Password")
        }
        
       

        // Realtime Database referansı3
        let realtimeDatabaseRef = Database.database().reference()

        // Firestore veri yapısını hazırlayın
        let firestorePost = [
                    
                        "namesurname": self.nameText.text!,
                        "email": self.emailText.text!,
                        "phone_country_code": self.countryText.text!,
                        "phonenumber": self.phoneText.text!
                    ]as [String: Any]
                    
                    
        realtimeDatabaseRef.child("Users").childByAutoId().setValue(firestorePost) { (error, ref) in
            if let error = error {
                self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
            } else {
                // Başarıyla eklendiğinde yapılacak işlemler
            }
        }
            
        }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil )
    }
    

}
extension RegisterVC {

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
