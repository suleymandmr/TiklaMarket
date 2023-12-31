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
        passwordText.isSecureTextEntry = true
        initializeHideKeyboard()
    }
    

    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailText.text, !email.isEmpty,
              
               let password = passwordText.text, !password.isEmpty else {
             makeAlert(titleInput: "Error", messageInput: "Username/Password")
             return
         }

        Auth.auth().signIn(withEmail: email, password: password) { [self] (authResult, error) in
             if let error = error {
                 self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
               print("hata")
                 
             } else {
                 self.saveUser(uid: Auth.auth().currentUser!.uid)
                 print("Kullanıcı oturum açtı, UID: \(email)")
             }
         }
    }
    
    func saveUser(uid: String) {
        let ref = Database.database().reference()
        
        ref.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot, error) in
            if let error = error {
               // print("Veri çekme hatası: \(error.localizedDescription)")
                return
            }
            
            if let userData = snapshot.value as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
                    let decoder = JSONDecoder()
                    let userDetails = try decoder.decode(UserModelDetails.self, from: jsonData)
                    
                    UserModel.shared = UserModel()
                    UserModel.shared.uid = uid
                    UserModel.shared.details = userDetails

                    // Şifreyi Keychain'e kaydet
                    if let passwordData = self.passwordText.text?.data(using: .utf8) {
                        KeychainHelper.save(passwordData, label: KeyChainKeys.password.rawValue)
                    }

                    // Kullanıcı oturum durumunu kaydet
                    UserDefaults.standard.setLoggedIn(value: true)

                    // UserModel'i cihazda sakla
                    let encoder = JSONEncoder()
                    if let user = try? encoder.encode(UserModel.shared) {
                        UserDefaults.standard.set(user, forKey: UserDefaultsKeys.userData.rawValue)
                    }
                    
                    // Ana ekrana yönlendir
                    self.performSegue(withIdentifier: "toMainVC", sender: nil)
                } catch {
                    print("Hata: \(error.localizedDescription)")
                }
            } else {
                print("Kullanıcı verileri bulunamadı.")
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
