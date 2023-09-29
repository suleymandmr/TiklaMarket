//
//  MainVC.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 15.08.2023.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorage
import MapKit
import CoreLocation
import FirebaseDatabase
import CoreData

class MainVC: UIViewController ,CLLocationManagerDelegate, MKMapViewDelegate{
    var ref: DatabaseReference!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var category: [String] = [String]()
    var categoryList = [Category]()
    var photoDataArray: [Category] = []
    var savedLocations = [CLLocationCoordinate2D]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization() // İzin iste
                locationManager.startUpdatingLocation()
        let layout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = 80 // Sabit genişlik değeri
        let cellHeight: CGFloat = 120 // Sabit yükseklik değeri
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        fetchRealtimeDatabaseData()
        checkUser()
        fetchSavedLocationsFromFirebase()
        fetchLocationsFromFirebase()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Haritayı temizleyin (eski pinleri kaldırın)
        

        // Firebase'den konum verilerini çekin ve haritada işaretleyin
        fetchSavedLocationsFromFirebase()
    }
    
    func checkUser(){
    
        if(UserDefaults.standard.isLoggedIn()){
            if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.userData.rawValue) {
                do {
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(UserModel.self, from: data)
                    print("USER ",user.email," ",user.uid)
                    UserModel.shared = user
                    
                    /*let data = KeychainHelper.read(label: KeyChainKeys.password.rawValue)
                    let password = String(data: data!, encoding: .utf8)!
                    print(password)*/
                    

                    
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
     
        } else {
            print("VERISI YOK ")
        
        }
        
    }
    func fetchLocationsFromFirebase() {
        var databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        // Firebase'den konum verilerini çekin
        // Firebase'den konum verilerini çekmek için uygun veri yolunu ve kullanıcı kimliğini kullanın
        databaseRef.child("Users/"+UserModel.shared.uid+"/address").observeSingleEvent(of: .value) { (snapshot) in
            if let locationsData = snapshot.value as? [String: Any] {
                for (_, locationData) in locationsData {
                    if let locationInfo = locationData as? [String: Any],
                       let latitude = locationInfo["latitude"] as? Double,
                       let longitude = locationInfo["longitude"] as? Double
                    {
                        // Her konum için bir işaretçi (pin) oluşturun ve haritaya ekleyin
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        self.mapView.addAnnotation(annotation)
                    }
                }
                
                // Haritayı işaretlenen konumların bulunduğu bölgeye odaklayın
                if let firstLocation = locationsData.first,
                   let locationInfo = firstLocation.value as? [String: Any],
                   let latitude = locationInfo["latitude"] as? Double,
                   let longitude = locationInfo["longitude"] as? Double
                {
                    let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: centerCoordinate, span: span)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    func fetchSavedLocationsFromFirebase() {
        let databaseRef = Database.database().reference().child("Users/\(UserModel.shared.uid)/address")
        databaseRef.observeSingleEvent(of: .value) { (snapshot, error) in
            if error != nil {
                print("Firebase veri alma hatası: ")
                return
            }

            if let locationData = snapshot.value as? [String: Any] {
                for (_, data) in locationData {
                    if let dataDict = data as? [String: Any],
                       let latitude = dataDict["latitude"] as? Double,
                       let longitude = dataDict["longitude"] as? Double {
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        self.savedLocations.append(coordinate)
                    }
                }
            }
        }
    }

    func showSelectedLocationOnMap(selectedCoordinate: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedCoordinate
            mapView.addAnnotation(annotation)
            
            // Seçilen konumu haritanın merkezine getirebilirsiniz
            let region = MKCoordinateRegion(center: selectedCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }

        // Kullanıcı daha önce seçilen bir konumu yansıtmak istediğinde bu fonksiyonu kullanabilirsiniz
        func showSavedLocationOnMap(savedCoordinate: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = savedCoordinate
            mapView.addAnnotation(annotation)
            
            // Mevcut konumu haritanın merkezine getirebilirsiniz
            let region = MKCoordinateRegion(center: savedCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
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
      
    func fetchRealtimeDatabaseData() {

        let db = Database.database().reference().child("Categories").queryOrderedByKey()
        db.observeSingleEvent(of: .value) { (snapshot) in
            guard let mainRealtime = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Realtime Database'den veri çekerken hata oluştu.")
                return
            }
            
            // Realtime Database verilerini sinemaListesi'ne ekleyelim
            for mainRealtime in mainRealtime {
                let mainData = mainRealtime.value as! [String: Any]
                if let title = mainData["CategoryName"] as? String,
                   let id = mainData["id"] as? Int,
                   let image = mainData["Image"] as? String {
                    let main = Category(id: id, title: title, Image: image)
                    self.categoryList.append(main)
                }
            }
            
            // Realtime Database verilerini aldıktan sonra gridview'i yenile
            self.collectionView.reloadData()
        }
        
    }
    
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionVC", for: indexPath) as! MainCollectionVC
                let main = categoryList[indexPath.row]
        cell.mainLabel.text = main.title
        cell.mainImageView.sd_setImage(with: URL(string: main.Image))
                return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoryList[indexPath.row]
        photoTapped(at: category)
        
    }
    
  
    
}
extension MainVC {
    func photoTapped(at category: Category) {
        
        //print("Photo tapped at index: \(id)")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
        next.selectedCategory = category
        //next.photoData = photoData
        //self.present(next, animated: true, completion: nil)
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}


