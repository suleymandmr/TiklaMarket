

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
class SearchVC: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    let SearchController = UISearchController(searchResultsController: nil)
    var activeProductList: [Product] = []

    var payArray = [String]()
    var searchImageArray = [String]()
    var nameArray = [String]()
    var searchList = [SearchItem]()
    
      override func viewDidLoad() {
          super.viewDidLoad()
          title = "Arama"
             navigationItem.searchController = SearchController
             SearchController.searchResultsUpdater = self
             initializeHideKeyboard()
             tableView.allowsSelection = true
             tableView.dataSource = self
             tableView.delegate = self

             // Verileri başlangıçta çekin
             fetchDataFromRealtimeDatabase()
      }
    
    func fetchDataFromRealtimeDatabase() {
        let productsRef = Database.database().reference().child("Products")

          productsRef.observeSingleEvent(of: .value, with: { (productSnapshot) in
              guard let productData = productSnapshot.value as? [String: Any] else {
                  print("Firebase Products veri bulunamadı.")
                  return
              }

              for (key, value) in productData {
                  if let productInfo = value as? [String: Any],
                     let name = productInfo["name"] as? String,
                     let fee = productInfo["productFee"] as? String,
                     let image = productInfo["Image"] as? String {
                      // Verileri güvenli bir şekilde çektikten sonra işlemleri yapabilirsiniz.
                      self.nameArray.append(name)
                      self.payArray.append(fee)
                      self.searchImageArray.append(image)

                      // searchList dizisine de ekleyin
                      let searchItem = SearchItem(name: name, fee: fee, image: image)
                      self.searchList.append(searchItem)
                  }
              }

              self.tableView.reloadData()
          }) { (error) in
              print("Firebase Products veri alma hatası: \(error.localizedDescription)")
          }
      }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty {
            // Arama çubuğu doluysa, verileri filtrele
            searchList.removeAll()
            for (index, name) in nameArray.enumerated() {
                if name.lowercased().contains(searchText) {
                    let searchItem = SearchItem(name: name, fee: payArray[index], image: searchImageArray[index])
                    searchList.append(searchItem)
                }
            }
        } else {
            // Arama çubuğu boşsa, tüm verileri göster
            searchList.removeAll()
            for (index, name) in nameArray.enumerated() {
                let searchItem = SearchItem(name: name, fee: payArray[index], image: searchImageArray[index])
                searchList.append(searchItem)
            }
        }

        // Tabloyu güncelle
        tableView.reloadData()
    }
    
  }
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
          
          let searchItem = searchList[indexPath.row]
          
          cell.payLabel.text = searchItem.fee + " tl"
          cell.nameLabel.text = searchItem.name
          cell.searchImageView.sd_setImage(with: URL(string: searchItem.image))
          
          return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        photoTapped(at: indexPath)
        
    }
    
}
extension SearchVC {
    func photoTapped(at indexPath: IndexPath) {
        
        print("Photo tapped at index: \(indexPath.row)")
                
                let next = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
//                sonraki sayfaya sınırlı veri geçişi
//                   next.relatedProducts = Array(activeProductList[0..<1])
        let selectedProduct = activeProductList[indexPath.row]
        next.selectedProduct = selectedProduct
                //next.photoData = photoData
                //self.present(next, animated: true, completion: nil)
                self.navigationController?.pushViewController(next, animated: true)
            }

}
extension SearchVC {

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
