//
//  shopsTableViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/9/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import CoreLocation

struct test {
    static var Shops: Shops? = nil
}

class shopsTableViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var shopsTableView: UITableView!
    
    var shops = [Shop]()
    var allShops: Shops?
    
    var mapShops = [String: GoogleMap]()
    var fonzyShops = [Int: Store]()
    var hairdressers = [Int: Independent]()
    
    
    // Table view cells are reused and should be dequeued using a cell identifier.
    let cellIdentifier = "shopCell"
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredShops = [Shop]()
    
    let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Shops"        
        //        navigationItem.searchController = searchController
        shopsTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true

        
        shopsTableView.delegate = self
        shopsTableView.dataSource = self
        
//        shops = dummyShops()
//        if let mapShops = allShops?.googleMaps {
//            shops = convert(googleMapsShops: mapShops)
//            shopsTableView.reloadData()
//        }
        
        if let userLocation = locationManager.location {
            let shopType = Search.type.rawValue
            ShopMethods.loadMapsShop(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, radius: 2500, shopType: shopType, shopOpenDate: "", shopOpenTime: "", shopOpenDay: "", shopAvgPrice: "", shopCities: "", completion: { (shops) in
                
                DispatchQueue.global(qos: .userInitiated).async {
                    self.convert(googleMapsShops: shops.googleMaps)
                    self.convert(stores: shops.stores)
                    self.convert(independents: shops.independents)
                }
                
                DispatchQueue.main.async {
                    self.shopsTableView.reloadData()
                }
            })
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

        let shop: Shop
        if isFiltering() {
            shop = filteredShops[indexPath.row]
        }else{
            shop = shops[indexPath.row]
        }
        
        cell.shopName.text = shop.name
        cell.shopStreetName.text = shop.status
        cell.shopProfileImage.image = shop.pictures?.first
        cell.shopDistance.text = shop.zipCode
        cell.shopRating.rating = Double(shop.rating!)
        cell.shopProfileImage.layer.cornerRadius = 0.5 * cell.shopProfileImage.bounds.width
        cell.shopProfileImage.clipsToBounds = true
        cell.shopProfileImage.contentMode = .scaleAspectFill
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //First: take shop id
        var shopId = shops[indexPath.row].id
        if(isFiltering()) {
            shopId = filteredShops[indexPath.row].id
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
            if let id = Int(shopId) {
                
                // Its from us, Fonzy
                
                //Second: instantiate the next view controller (shop profile)
                
                let nextViewController = storyboard.instantiateViewController(withIdentifier: "shopProfileNavC") as! UINavigationController
                
                let shopProfile = nextViewController.topViewController as! ShopProfileViewController
                shopProfile.shop = fonzyShops[id]
                
                //Third: find the top most view controller and present the shop profile there
                
                // Note: this code is from StackOverFlow
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.present(nextViewController, animated: true, completion: nil)
                }
                
                
            }else{
                // Its from GMaps
                
                let nextViewController = storyboard.instantiateViewController(withIdentifier: "googleMapShopProfileNavC") as! UINavigationController
                let shopProfile = nextViewController.topViewController as! GoogleMapShopProfileViewController
                shopProfile.shopMapImage = takeMapImage()
                shopProfile.shop = mapShops[shopId]//shops?.googleMaps[4]
                
                // Note: this code is from StackOverFlow
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.present(nextViewController, animated: true, completion: nil)
                }
            }
        
        

    }
 

    
    
    
    // MARK: - Search bar methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredShops = shops.filter({( shop : Shop) -> Bool in
            return shop.name.lowercased().contains(searchText.lowercased())
        })
        
        shopsTableView.reloadData()
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }
    
    
    func convert(googleMapsShops: [GoogleMap]) /*-> [Shop]*/ {
        
//        var shops = [Shop]()
        for shop in googleMapsShops {
            let newShop = Shop(withId: shop.id, name: shop.name, status: "\(String(describing: shop.openingHours?.openNow))", longitude: shop.geometry.location.lng, latitude: shop.geometry.location.lat, zipCode: "", description: "", rating: 5/*Int(ceil(shop.rating!))*/, pictures: [UIImage(named: "6")!])
            
            self.shops.append(newShop)
            self.mapShops[shop.id] = shop
        }
//        return shops
    }
    
    func convert(stores: [Store]) /*-> [Shop]*/ {
        
//        var shops = [Shop]()
        for store in stores {
            let zipCode = store.zipCode ?? ""
            let description = store.description ?? ""
            let ratingString = store.ratings ?? ""
            let rating = Double(ratingString) ?? 0
            let ratingInt = Int(ceil(rating))
            
            
            let newShop = Shop(withId: "\(store.id)", name: store.name, status: "Active", longitude: store.longitude, latitude: store.latitude, zipCode: zipCode, description: description, rating: ratingInt, pictures: [UIImage(named: "6")!])
            
            self.fonzyShops[store.id] = store
            self.shops.append(newShop)

        }
//        return shops
    }
    
    func convert(independents: [HairdresserJSON]) /*-> [Shop]*/ {
        
//        var shops = [Shop]()
        for independent in independents {
            let zipCode = independent.user.hairdresserInformation?.address?.zipCode ?? ""
            let description =             independent.user.hairdresserInformation?.description
 ?? ""
            let ratingString = independent.info.rating ?? ""
            let rating = Int(ratingString) ?? 0
            let firstName = independent.user.firstName ?? "No name"
            let lastName = independent.user.lastName ?? ""
            let name = firstName + " " + lastName
            let latitudeString = independent.user.hairdresserInformation?.latitude ?? ""
            let longitudeString =             independent.user.hairdresserInformation?.longitude ?? ""
            let latitude = Double(latitudeString) ?? 0.0
            let longitude = Double(longitudeString) ?? 0.0

            // Load hairdresser profile picture
            var profilePicture = UIImage(named: "user")!
            
            let imageString = independent.user.profilePicture?.medium ?? ""
            let imgUrl = URL(string: imageString)
            if let imgUrl = imgUrl {
                let urlContents = try? Data(contentsOf: imgUrl)
                if let imageData = urlContents {
                    if let image = UIImage(data: imageData) {
                        profilePicture = image
                    }
                }
            }
            
            
            
            let newHairdresser = Shop(withId: "\(independent.info.id)", name: name, status: "Active", longitude: longitude, latitude: latitude, zipCode: zipCode, description: description, rating: rating, pictures: [profilePicture])
            
            guard let hairdresserInformation = independent.user.hairdresserInformation else {return}
            self.hairdressers[independent.info.id] = hairdresserInformation
            self.shops.append(newHairdresser)
            
        }
//        return shops
    }

    func takeMapImage() -> UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
}



extension shopsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
