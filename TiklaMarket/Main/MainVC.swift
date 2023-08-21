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
import XLPagerTabStrip
class MainVC: UIViewController ,CLLocationManagerDelegate, MKMapViewDelegate{
    var ref: DatabaseReference!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var katogori: [String] = [String]()
    var katogoriListesi = [Category]()
    var photoDataArray: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.requestWhenInUseAuthorization()
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
        
        
        
        
       
    }
 
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
               let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
               let region = MKCoordinateRegion(center: location, span: span)
               mapView.setRegion(region, animated: true)
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
                    self.katogoriListesi.append(main)
                }
            }
            
            // Realtime Database verilerini aldıktan sonra gridview'i yenile
            self.collectionView.reloadData()
        }
        
    }
    
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return katogoriListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionVC", for: indexPath) as! MainCollectionVC
                let main = katogoriListesi[indexPath.row]
        cell.mainLabel.text = main.title
        cell.mainImageView.sd_setImage(with: URL(string: main.Image))
                return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = katogoriListesi[indexPath.row]
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

