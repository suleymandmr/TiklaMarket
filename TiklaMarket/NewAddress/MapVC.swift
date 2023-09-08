import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
  
    @IBOutlet weak var saveButton: UIButton!
    let locationManager = CLLocationManager()
    let databaseRef = Database.database().reference()
    var selectedPinCoordinate: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
               
               mapView.delegate = self
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               
               // Kullanıcının konum iznini iste
               locationManager.requestWhenInUseAuthorization()
               
               // Haritayı kullanıcının konumuna merkezle
               mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
               // Haritaya pin eklemek için bir jest tanımla (örneğin, uzun dokunma)
               let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
               mapView.addGestureRecognizer(longPressGesture)
               
               // "Kaydet" butonuna işlev eklemek için addTarget kullanın
               saveButton.addTarget(self, action: #selector(addPinButtonClicked(_:)), for: .touchUpInside)
                // Başlangıçta gizli yapabilirsiniz
    }
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
    
    @objc func addPin(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
                   let touchPoint = gestureRecognizer.location(in: mapView)
                   let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                   
                   // Pin oluşturun ve haritaya ekleyin
                   let pin = MKPointAnnotation()
                   pin.coordinate = coordinate
                   mapView.addAnnotation(pin)
                   
                   // Seçilen pin'in koordinatlarını saklayın
                   selectedPinCoordinate = coordinate
                   
                   // "Kaydet" butonunu görünür yapın
                   
               }
      }
    
    @IBAction func addPinButtonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Eğer farklı bir storyboard kullanıyorsanız onun adını verin
        if let secondViewController = storyboard.instantiateViewController(withIdentifier: "NewAddressDetailVC") as? NewAddressDetailVC {
            navigationController?.pushViewController(secondViewController, animated: true)
            tabBarController?.tabBar.tabsVisiblty(false)
            
        }
        guard let coordinate = selectedPinCoordinate else {
                  return // Eğer seçili bir pin yoksa kaydetmeyi denemeyin
              }
              
              // Pin'in konumunu Firebase'e kaydedin
              let pinData = ["latitude": coordinate.latitude, "longitude": coordinate.longitude]
              databaseRef.child("pins").childByAutoId().setValue(pinData) { (error, _) in
                  if let error = error {
                      print("Hata: \(error.localizedDescription)")
                  } else {
                      print("Pin başarıyla Firebase'e kaydedildi.")
                  }
              }
              
              // "Kaydet" butonunu tekrar gizleyin
             
          
        }
  
}
