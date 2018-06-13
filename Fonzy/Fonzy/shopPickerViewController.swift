//
//  shopPickerViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/2/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftKeychainWrapper

class shopPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userRole = Role.shopOwner
    
    @IBOutlet weak var shopsTableView: UITableView!
    @IBOutlet weak var createShopButton: UIButton!
    
    // Custom activity indicator properties
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var shops = [Store]()
    let cellIdentifier = "shopCell"
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredShops = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Shops"
        //        searchController.searchBar.barTintColor = UIColor.red
        //        navigationItem.searchController = searchController
        shopsTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        // Do any additional setup after loading the view.
        
        shopsTableView.delegate = self
        shopsTableView.dataSource = self
        
//        shops = dummyShops()
        loadShops()
        
        
        // Show "create shop button" only on shopOwner
        if userRole == .hairdresser {
            createShopButton.setTitle("I am an independent Hairdresser", for: .normal)
//            createShopButton.isHidden = true
        }
        // On hairdresser, flow is over once they press a shop
        
        
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if isFiltering() {
            return filteredShops.count
        }
        
        return shops.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? shopsTableViewCell else {
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        let shop: Store
        if isFiltering() {
            shop = filteredShops[indexPath.row]
        }else{
            shop = shops[indexPath.row]
        }
        let rating = shop.ratings ?? "0.0"
        let shopRating = Double(rating) ?? 0.0
        
        cell.shopName.text = shop.name
//        cell.shopStreetName.text =
        cell.shopProfileImage.image = UIImage(named: "6")//
        cell.shopDistance.text = shop.zipCode
        cell.shopRating.rating = shopRating
        cell.shopProfileImage.layer.cornerRadius = 0.5 * cell.shopProfileImage.bounds.size.width
        cell.shopProfileImage.contentMode = .scaleAspectFill
        cell.shopProfileImage.clipsToBounds = true
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedShopId = shops[indexPath.row].id
        
        if userRole == .hairdresser {
           displayHairdresserRequest(toShop: selectedShopId)
        } else if userRole == .shopOwner {
            displayShopOwnerRequest(toShop: selectedShopId)
        }
        
    }
    
    func displayHairdresserRequest(toShop id: Int) {
        let alert = UIAlertController(title: "Send Request", message: "Send a request to the shop owner to accept you as a hairdresser", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                DispatchQueue.main.async {
                    self.activityIndicator("Sending request")
                }
                self.sendHairdresserRequest(toShop: id)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("!!!!!!!!!!!!!!!destructive")
                
            }}))
    }
    
    func sendHairdresserRequest(toShop id: Int) {
        
        guard let userToken = KeychainWrapper.standard.string(forKey: "authToken") else {return}
        let link = Config.fonzyUrl + "users/hairdressers/stores"
        var url = URLComponents(string: link)!
        
        url.queryItems = [
            URLQueryItem(name: "store_id", value: "\(id)"),
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "PUT"
        request.addValue(userToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
            
            print("heeey response: ", response)
            print("Hey data: ", data)
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
                
                let storyboard = UIStoryboard(name:"Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "loginViewController")
                self?.present(controller, animated: true, completion: nil)
            }
            
        }.resume()
        
    }
    
    func displayShopOwnerRequest(toShop id: Int) {
        
        let alert = UIAlertController(title: "Send Request", message: "Request shopOwner permission", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: {[weak self] action in
            switch action.style{
            case .default:
                // Enviar request a shopOwner
                DispatchQueue.main.async {
                    self?.activityIndicator("Sending request")
                }
                self?.sendShopOwnerRequest(toShop: id)
                
                
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("!!!!!!!!!!!!!!!destructive")
                
            }}))
    }
    
    func sendShopOwnerRequest(toShop id: Int) {
        
        guard let userToken = KeychainWrapper.standard.string(forKey: "authToken") else {return}
        let link = Config.fonzyUrl + "stores/store_transactions"
        var url = URLComponents(string: link)!
        
        url.queryItems = [
            URLQueryItem(name: "store_id", value: "\(id)"),
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.addValue(userToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
            
            print("heeey response: ", response)
            print("Hey data: ", data)
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
                let storyboard = UIStoryboard(name:"Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "viewController")
                self?.present(controller, animated: true, completion: nil)
            }
        }.resume()
        
    }
    
    // MARK: - Search bar methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredShops = shops.filter({( shop : Store) -> Bool in
            return shop.name.lowercased().contains(searchText.lowercased())
        })
        
        shopsTableView.reloadData()
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - fetching methods

    
    func loadShops() {
        let pageNumber = 1
        let link = Config.fonzyUrl + "find/list?page=\(pageNumber)"
       
        guard let url = URL(string: link) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
        
            print("Get all shops response: ", response)
            guard let data = data else {return}
            
            do{
                
                self?.shops = try JSONDecoder().decode([Store].self, from: data)
                
                print("Shops parsing successed: ", self?.shops.count)
                
                DispatchQueue.main.async {
                    self?.shopsTableView.reloadData()
                }
                
            } catch let err {
                print("Error while parsing all backend shops: ", err)
            }
            
        }.resume()
        
        
    }
    
    
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        effectView.removeFromSuperview()
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let destination = segue.destination as? locationViewController {
            destination.userRole = userRole
        }
     }
    
    
    
    @IBAction func unwindToShopPickerVC(segue: UIStoryboardSegue){
    }
    
    
}


extension shopPickerViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}



