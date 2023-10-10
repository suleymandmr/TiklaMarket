import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ProfileEditVC: UIViewController {
    
    @IBOutlet weak var nameSurnameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneNumberText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Populate the fields with UserModel.shared data
        nameSurnameText.text = UserModel.shared.details.nameSurname
        emailText.text = UserModel.shared.details.email
        phoneNumberText.text = UserModel.shared.details.phoneNumber
    }
    
    @IBAction func SaveClicked(_ sender: Any) {
        guard let newEmail = emailText.text,
              let newNameSurname = nameSurnameText.text,
              let newPhoneNumber = phoneNumberText.text,
              let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Update the Firebase Authentication email
        Auth.auth().currentUser?.updateEmail(to: newEmail) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print("Email güncelleme hatası: \(error.localizedDescription)")
            } else {
                print("Email başarıyla güncellendi.")
                
                // Update the Firebase Realtime Database user details
                let ref = Database.database().reference().child("Users").child(currentUserID)
                
                let userDetails = [
                    "nameSurname": newNameSurname,
                    "email": newEmail,
                    "phoneNumber": newPhoneNumber
                ]
                
                ref.updateChildValues(userDetails) { (error, ref) in
                    if let error = error {
                        print("Veri güncelleme hatası: \(error.localizedDescription)")
                    } else {
                        print("Veri başarıyla güncellendi.")
                        
                        // Update UserModel.shared with the new data
                        UserModel.shared.details.nameSurname = newNameSurname
                        UserModel.shared.details.email = newEmail
                        UserModel.shared.details.phoneNumber = newPhoneNumber
                    }
                }
            }
        }
    }
}

extension ProfileEditVC {
    func initializeHideKeyboard() {
        // Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        // Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        // endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        // In short, dismiss the active keyboard.
        view.endEditing(true)
    }
}
