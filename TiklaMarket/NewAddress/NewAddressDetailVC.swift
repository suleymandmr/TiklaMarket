

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase



class NewAddressDetailVC: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate {
    var addressType: String?
    
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
                self.fetchUserProfile()
            } else {
                // Kullanıcı oturum açmamışsa, uygun bir şekilde yönlendirme yapabiliriz.
                print("Kullanıcı oturum açmamış.")
            }
        }
    }
    
    // Kullanıcının konum güncellemeleri alındığında çağrılır
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.last {
               let latitude = location.coordinate.latitude
               let longitude = location.coordinate.longitude
               
               // Konum bilgilerini kullanabilirsiniz
               print("Latitude: \(latitude), Longitude: \(longitude)")

               // Haritada kullanıcının konumunu merkezlemek için
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
    func fetchUserProfile() {
        
        guard let userID = self.currentUserID else {
            return
        }
        let ref = Database.database().reference()
        ref.child("Addresses").child(userID).observeSingleEvent(of: .value) { (snapshot, error) in
            if let userData = snapshot.value as? [String: Any] {
                self.titleText.text = userData["adres_baslik"] as? String
                self.directionsText.text = userData["adres_tarifi"] as? String
                self.buildText.text = userData["bina_no"] as? String
                self.apartmentNumberText.text = userData["daire_no"] as? String
                self.flourText.text = userData["kat"] as? String
                self.streetText.text = userData["mahalle_cadde_sokak"] as? String
                
            } else {
                print("Kullanıcı verileri bulunamadı.")
            }
        } withCancel: { (error) in
            print("Veri çekme hatası: \(error.localizedDescription)")
        }
    }
    
    @IBAction func buildingClicked(_ sender: Any) {
        addressType = "iş"
    }
    @IBAction func homeClicked(_ sender: Any) {
        addressType = "ev"
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
              let newStreetText = streetText.text,
              let addressType = addressType,
              let userID = self.currentUserID else {
            return
        }
        let ref = Database.database().reference()
        let userRef = ref.child("Addresses").child(userID)
        userRef.updateChildValues(["adres_baslik": newTitleText,"adres_tarifi": newDirectionsText, "bina_no": newBuildText, "daire_no" : newApartmentNumberText, "kat": newFlourText, "mahalle_cadde_sokak": newStreetText, "adresTip" : addressType ]) { (error, ref) in
            if let error = error {
                print("Veri güncelleme hatası: \(error.localizedDescription)")
            } else {
                print("Veri başarıyla güncellendi.")
            }
        }
    }
}
