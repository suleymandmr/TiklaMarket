//
//  AddressVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 29.08.2023.
//

import UIKit
import Firebase
import FirebaseDatabase
class AddressVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextViewClicted(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Eğer farklı bir storyboard kullanıyorsanız onun adını verin
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "MapVC") as? MapVC {
            navigationController?.pushViewController(secondViewController, animated: true)
            tabBarController?.tabBar.tabsVisiblty(false)
            
        }
    }
 

}
