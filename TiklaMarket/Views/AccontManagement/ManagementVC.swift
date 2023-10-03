//
//  ManagementVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 29.08.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class ManagementVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func deleteProfileClicked(_ sender: Any) {
        // Firebase Authentication'dan kullanıcıyı al
        if let user = Auth.auth().currentUser {
            // Firebase Authentication'dan hesabı sil
            user.delete { error in
                if let error = error {
                    print("Hesap silinemedi: \(error.localizedDescription)")
                } else {
                    print("Hesap başarıyla silindi.")
                    
                    if let userId = Auth.auth().currentUser?.uid {
                        let ref = Database.database().reference().child("Users").child(userId)
                        
                        // Firebase Realtime Database'den verileri sil
                        ref.removeValue { error, _ in
                            if let error = error {
                                print("Veriler silinemedi: \(error.localizedDescription)")
                            } else {
                                print("Veriler başarıyla silindi.")
                            }
                            
                            // Firebase Authentication'dan çıkış yapın
                            try? Auth.auth().signOut()
                            
                            // Hesap silindiğinde diğer işlemleri gerçekleştirin (örneğin, kullanıcıyı başka bir ekrana yönlendirme)
                        }
                    }
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
