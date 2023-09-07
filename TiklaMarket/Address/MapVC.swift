import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Harita görünümünün delegesini ayarla
        mapView.delegate = self
        
        // Konum izni al
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Haritayı başlangıç konumuyla görüntüle
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        // Firebase ile bağlantıyı kur
        FirebaseApp.configure()
    }
    
    // Konum izni değişikliklerini ele al
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    // Konum güncellemelerini ele al
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Konumu al
            let userLocation = location.coordinate
            
            // Haritayı güncelle
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    @IBAction func addPinButtonClicked(_ sender: UIButton) {
        // Seçili konumu al
        let selectedLocation = mapView.centerCoordinate
        
        // Firebase Realtime Database'e kaydetmek için bir referans oluştur
        let ref = Database.database().reference().child("Pins")
        
        // Yeni bir benzersiz bir pin ID'si oluştur veya mevcut bir sistemle tanımla
        let newPinRef = ref.childByAutoId()
        
        // Pin verilerini hazırla (latitude ve longitude)
        let pinData = ["latitude": selectedLocation.latitude,
                       "longitude": selectedLocation.longitude]
        
        // Pin verilerini Firebase'e kaydet
        newPinRef.setValue(pinData) { (error, _) in
            if let error = error {
                print("Pin kaydetme hatası: \(error.localizedDescription)")
            } else {
                print("Pin başarıyla kaydedildi.")
            }
        }
    }
}
