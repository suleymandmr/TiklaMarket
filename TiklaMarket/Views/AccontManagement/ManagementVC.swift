import UIKit
import Firebase
import FirebaseAuth

class ManagementVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func deleteProfileClicked(_ sender: Any) {
        // Firebase Authentication'dan kullanıcıyı al
        if let user = Auth.auth().currentUser {
            // Firebase Authentication'dan hesabı sil
            user.delete { error in
                if let error = error {
                    // Hata durumunda kullanıcıya bilgi ver
                    print("Hesap silinemedi: \(error.localizedDescription)")
                } else {
                    // Hesap başarıyla silindiyse devam edin
                    print("Hesap başarıyla silindi.")
                    
                    if let userId = Auth.auth().currentUser?.uid {
                        let ref = Database.database().reference().child("Users").child(userId)
                        
                        // Firebase Realtime Database'den verileri sil
                        ref.removeValue { error, _ in
                            if let error = error {
                                // Hata durumunda kullanıcıya bilgi ver
                                print("Veriler silinemedi: \(error.localizedDescription)")
                            } else {
                                // Veriler başarıyla silindiyse devam edin
                                print("Veriler başarıyla silindi.")
                            }
                            
                            // Firebase Authentication'dan çıkış yapın
                            try? Auth.auth().signOut()
                            
                            // Hesap silindiğinde başka bir işlem yapabilirsiniz, örneğin kullanıcıyı başka bir ekrana yönlendirebilirsiniz
                        }
                    }
                }
            }
        }
    }
}
