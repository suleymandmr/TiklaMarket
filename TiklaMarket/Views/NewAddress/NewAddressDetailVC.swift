

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase



class NewAddressDetailVC: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate {
    let address = AddressModel()
    @IBOutlet weak var streetText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var directionsText: UITextField!
    @IBOutlet weak var apartmentNumberText: UITextField!
    @IBOutlet weak var flourText: UITextField!
    @IBOutlet weak var buildText: UITextField!
    
    let locationManager = CLLocationManager()
    var currentUserID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization() // İzin iste
                locationManager.startUpdatingLocation()
       
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // Kullanıcı oturum açmışsa, kullanıcının kimliğini alıyoruz
                self.currentUserID = user.uid
                
                // Kullanıcının profil verilerini çekiyoruz ve ekranda gösteriyoruz
      
            } else {
                // Kullanıcı oturum açmamışsa, uygun bir şekilde yönlendirme yapabiliriz.
                print("Kullanıcı oturum açmamış.")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("SAYFA GELDİ 1 ",address )
        print("SAYFA GELDİ ",address.latitude," ",address.longitude)
    }
    
    // Kullanıcının konum güncellemeleri alındığında çağrılır
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.last {
               let latitude = location.coordinate.latitude
               let longitude = location.coordinate.longitude
               
               // Konum bilgilerini kullanabilirsiniz
               print("NEW ADRESS Latitude: \(latitude), Longitude: \(longitude)")

               // Haritada kusllanıcının konumunu merkezlemek için
               let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
               mapView.setRegion(region, animated: true)
           }
       }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           if status == .authorizedWhenInUse {
               // İzin verildi, konum güncellemelerini başlat
               locationManager.startUpdatingLocation()
           } else {
               // İzin reddedildi veya kullanıcı izin vermedi, uygun bir işlem yapabilirsiniz
           }
       }
    
    @IBAction func buildingClicked(_ sender: Any) {
        address.type = AddressTypes.office.rawValue
    }
    @IBAction func homeClicked(_ sender: Any) {
        address.type = AddressTypes.home.rawValue
    }
    
    
    @IBAction func saveClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Eğer farklı bir storyboard kullanıyorsanız onun adını verin
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
            navigationController?.pushViewController(secondViewController, animated: true)
            tabBarController?.tabBar.tabsVisiblty(true)
            
        }
        guard let newTitleText = titleText.text,
              let newDirectionsText = directionsText.text,
              let newBuildText = buildText.text,
              let newApartmentNumberText = apartmentNumberText.text,
              let newFlourText = flourText.text,
              let newStreetText = streetText.text else {
            return
        }
        
        address.title           = newTitleText
        address.description     = newDirectionsText
        address.buildingNumber  = newBuildText
        address.apartmentNumber = newApartmentNumberText
        address.floor           = newFlourText
        address.district        = newStreetText
    
        //UPDATE İŞLEMINDE PUSH EDİLECEK..
        do{
            UserModel.shared.details.address.append(address)
            let encoder = JSONEncoder()
            let user = try encoder.encode(UserModel.shared)
            //save user data & password
            UserDefaults.standard.set(user, forKey: UserDefaultsKeys.userData.rawValue)
            
            //map filter reduce
            let arr = UserModel.shared.details.address.map({ $0.getAllData() })
            let ref = Database.database().reference()
            let userRef = ref.child("Users/"+UserModel.shared.uid+"/address")
            userRef.setValue(arr)
        }catch {}
        //print("DATAAA ",userRef.key)
        
        
        /*userRef.updateChildValues(["adres_baslik": newTitleText,"adres_tarifi": newDirectionsText, "bina_no": newBuildText, "daire_no" : newApartmentNumberText, "kat": newFlourText, "mahalle_cadde_sokak": newStreetText, "adresTip" : 1 ]) { (error, ref) in
            if let error = error {
                print("Veri güncelleme hatası: \(error.localizedDescription)")
            } else {
                print("Veri başarıyla güncellendi.")
            }
        }*/
        
    }
}
extension NewAddressDetailVC {

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
