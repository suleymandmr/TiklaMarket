//
//  ProfileEditVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 4.09.2023.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileEditVC: UIViewController {
    
    @IBOutlet weak var nameSurnameText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var phoneNumberText: UITextField!
    var currentUserID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // Kullanıcı oturum açmışsa, kullanıcının kimliğini alıyoruz
                self.currentUserID = user.uid
                
                // Kullanıcının profil verilerini çekiyoruz ve ekranda gösteriyoruz
                self.fetchUserProfile()
            } else {
                // Kullanıcı oturum açmamışsa, uygun bir şekilde yönlendirme yapabiliriz.
                print("Kullanıcı oturum açmamış.")
            }
        }
        
    }
    func fetchUserProfile() {
        guard let userID = self.currentUserID else {
            return
        }
        let ref = Database.database().reference()
        
        ref.child("Users").child(userID).observeSingleEvent(of: .value) { (snapshot, error) in
            if let userData = snapshot.value as? [String: Any] {
                self.emailText.text = userData["email"] as? String
                self.phoneNumberText.text = userData["phonenumber"] as? String
                self.nameSurnameText.text = userData["namesurname"] as? String
            } else {
                print("Kullanıcı verileri bulunamadı.")
            }
        } withCancel: { (error) in
            print("Veri çekme hatası: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
    @IBAction func SaveClicked(_ sender: Any) {
        guard let newEmail = emailText.text,
              let newNameSurname = nameSurnameText.text,
              let newPhoneNumber = phoneNumberText.text,
              let userID = self.currentUserID else {
            return
        }
        
        let user = Auth.auth().currentUser
        
        user?.updateEmail(to: newEmail) { (error) in
            if let error = error {
                print("Email güncelleme hatası: \(error.localizedDescription)")
            } else {
                print("Email başarıyla güncellendi.")
                
                // Email güncellendiyse, veritabanındaki kullanıcı bilgilerini güncelle
                let ref = Database.database().reference()
                let userRef = ref.child("Users").child(userID)
                userRef.updateChildValues(["namesurname": newNameSurname, "email": newEmail, "phonenumber": newPhoneNumber]) { (error, ref) in
                    if let error = error {
                        print("Veri güncelleme hatası: \(error.localizedDescription)")
                    } else {
                        print("Veri başarıyla güncellendi.")
                    }
                }
            }
        }
    }
}