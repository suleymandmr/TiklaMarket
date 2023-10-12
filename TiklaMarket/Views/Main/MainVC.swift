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
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        print("Deneme\(UserModel.shared.selectedAddressID)")
        if(UserModel.shared.selectedAddressID != -1){
            mapView.removeAnnotations(mapView.annotations)
            let activeLat = CLLocationDegrees(UserModel.shared.details.address[UserModel.shared.selectedAddressID].latitude)
            let activeLong = CLLocationDegrees(UserModel.shared.details.address[UserModel.shared.selectedAddressID].longitude)
            
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude:activeLat, longitude: activeLong)
            pin.title = "Gönderilecek Adres"
            updateMapForCoordinate(coordinate: pin.coordinate)
            mapView.addAnnotation(pin)
            
        }

        
    }
    
    func updateMapForCoordinate(coordinate: CLLocationCoordinate2D) {
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 1000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: false)
        var center = coordinate;
        center.latitude -= self.mapView.region.span.latitudeDelta / 6.0;
        mapView.setCenter(center, animated: false);
    }
    func bagsCheck() {
        let ref = Database.database().reference()
        let query = "Users/" + UserModel.shared.uid + "/bags"
        ref.child(query).observeSingleEvent(of: .value) { (snapshot, error) in
            
            if let bagData = snapshot.value as? [String: Any] {
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: bagData, options: [])
                    let decoder = JSONDecoder()
                    let bagsModel = try decoder.decode(BagsModel.self, from: jsonData)
                    
                    UserModel.shared.details.bags = bagsModel
                }catch{}
            }else{
                UserModel.shared.details.bags = BagsModel()
                print("testtt")
            }
        }
    }

    
    func checkUser(){
    
        if(UserDefaults.standard.isLoggedIn()){
            if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.userData.rawValue) {
                do {
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(UserModel.self, from: data)
                    UserModel.shared = user
                    bagsCheck()
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
          
           if(UserModel.shared.selectedAddressID == -1){
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


