//
//  ProfileVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 29.08.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class ProfileVC: UIViewController {
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
  
    @IBOutlet weak var emailLabel: UILabel!
    
    var ref : DatabaseReference!
    
    var currentUserID: String?
    var didRedirectToProfile = false
    override func viewDidLoad() {
        super.viewDidLoad()
        /*Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // Kullanıcı oturum açmışsa, kullanıcının kimliğini alıyoruz
                self.currentUserID = user.uid
                
                // Kullanıcının profil verilerini çekiyoruz ve ekranda gösteriyoruz
                //self.fetchUserProfile()
            } else {
                // Kullanıcı oturum açmamışsa, uygun bir şekilde yönlendirme yapabiliriz.
                self.navigateToLogin()
            }
        }
        profile()*/
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        phoneNumberLabel.text = UserModel.shared.phoneNumber
        nameSurnameLabel.text = UserModel.shared.nameSurname
        emailLabel.text = UserModel.shared.email
    }

   

    
    /*
    
    func fetchUserProfile() {
        // Firebase Realtime Database referansını alın
        let ref = Database.database().reference()
        
        // Şu anki kullanıcının UID'sini alın
        if let userID = Auth.auth().currentUser?.uid {
            print("kullanıcıtest\(userID)")
            // Kullanıcının bilgilerini Realtime Database'den çekin
            ref.child("Users").child(userID).queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot, error) in
                if let userData = snapshot.value as? [String: Any] {
                    // Kullanıcının bilgilerini çekin
                    if let email = userData["email"] as? String {
                        self.emailLabel.text = "E-posta: \(email)"
                        print("emailtest\(email)")
                    }
                    if let nameSurname = userData["namesurname"] as? String {
                        self.nameSurnameLabel.text = "Ad Soyad: \(nameSurname)"
                    }
                    if let phoneNumber = userData["phonenumber"] as? String {
                        self.phoneNumberLabel.text = "Telefon: \(phoneNumber)"
                    }
                    if userData["phone_country_code"] is String {
                        
                    }
                } else {
                    print("Kullanıcı verileri bulunamadı.")
                }
            } withCancel: { (error) in
                print("Veri çekme hatası: \(error.localizedDescription)")
            }
        }
    }
    */
    
    
    func navigateToProfile() {
        _ = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
    }
    
    func navigateToLogin() {
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.navigationItem.setHidesBackButton(true, animated: false)
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.tabsVisiblty(true)
        
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLoginVC", sender: nil)
            
        } catch {
            print("error")
        }
    }
    
    
    @IBAction func accontMenagmentClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Eğer farklı bir storyboard kullanıyorsanız onun adını verin
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "ManagementVC") as? ManagementVC {
            navigationController?.pushViewController(secondViewController, animated: true)
            
            
            tabBarController?.tabBar.tabsVisiblty(false)
            
        }
    }
    
    @IBAction func pastOrdersClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Eğer farklı bir storyboard kullanıyorsanız onun adını verin
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "PastOrdersVC") as? PastOrdersVC {
            navigationController?.pushViewController(secondViewController, animated: true)
            tabBarController?.tabBar.tabsVisiblty(false)
            
        }
    }
    
    @IBAction func addressClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Eğer farklı bir storyboard kullanıyorsanız onun adını verin
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC {
            navigationController?.pushViewController(secondViewController, animated: true)
            tabBarController?.tabBar.tabsVisiblty(false)
            
        }
    }
    
    @IBAction func editClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Eğer farklı bir storyboard kullanıyorsanız onun adını verin
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "ProfileEditVC") as? ProfileEditVC {
            navigationController?.pushViewController(secondViewController, animated: true)
            tabBarController?.tabBar.tabsVisiblty(false)
        }
        
        
    }
}
extension UITabBar {
    func tabsVisiblty(_ isVisiblty: Bool = true){
        if isVisiblty {
            self.isHidden = false
            self.layer.zPosition = 0
        } else {
            self.isHidden = true
            self.layer.zPosition = -1
        }
    }
}
