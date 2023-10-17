import UIKit
import SDWebImage
import Firebase

class SearchVC: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var activeProductList: [Product] = []
    var searchList: [Product] = []
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Arama"
        tableView.dataSource = self
        tableView.delegate = self
        // Verileri başlangıçta çekin
        Task {
            await fetchDataFromRealtimeDatabase()
        }
        
        // UISearchController ayarları
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task {
            await fetchDataFromRealtimeDatabase()
        }
    }
    
    func fetchDataFromRealtimeDatabase() async {
        let data = await Api().getSearchProductData(name: "")
        self.activeProductList = data ?? []
        
        for product in activeProductList {
            
            self.searchList.append(product)
        }
        
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), !searchText.isEmpty {
            // Arama çubuğu doluysa, verileri filtrele
            searchList.removeAll()
            for product in activeProductList {
                if product.name.lowercased().contains(searchText) {
                   
                    searchList.append(product)
                }
            }
        } else {
            // Arama çubuğu boşsa, tüm verileri göster
            searchList.removeAll()
            for product in activeProductList {
                
                searchList.append(product)
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
        
        cell.payLabel.text = searchItem.pay! + " tl"
        cell.nameLabel.text = searchItem.name
        cell.searchImageView.sd_setImage(with: URL(string: searchItem.imageURL!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        if((searchController.searchBar.text?.isEmpty) != false){
            let selectedProduct = activeProductList[indexPath.row]
            navigateToProductDetail(selectedProduct: selectedProduct)
          
        }else{
            let selectedProduct = searchList[indexPath.row]
            navigateToProductDetail(selectedProduct: selectedProduct)
            print("searchList\(searchList[indexPath.row].name)")
            
           /* do {
                let product = try await Api().getProductByName(searchList[indexPath.row].name)
               navigateToProductDetail(selectedProduct: product)
           } catch {
               // Hata işleme burada yapılabilir
               print("Hata: \(error)")
           }*/
        }
        
        print("searchBar\(searchController.searchBar.text)")
    }
    
    func navigateToProductDetail(selectedProduct: Product) {
        guard let productDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC else {
            return
        }
        productDetailVC.selectedProduct = selectedProduct
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    func initializeHideKeyboard() {
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short - Dismiss the active keyboard.
        view.endEditing(true)
    }
}
