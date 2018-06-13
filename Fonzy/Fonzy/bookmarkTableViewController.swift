//
//  bookmarkTableViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/8/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class bookmarkTableViewController: UITableViewController {

    var bookmarks = [Bookmark]()
    
    let cellIdentifier = "bookmarkCell"
    
    @IBOutlet var bookmarkTableView: UITableView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        navItem.rightBarButtonItem = self.editButtonItem
        
//        loadDummyBookmarks()
        loadBookmarks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookmarks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? bookmarkTableViewCell else {
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        // Configure the cell...

        let bookmark = bookmarks[indexPath.row]
        
        cell.shopIcon.image = bookmark.shopIcon
        cell.name.text = bookmark.shopName
        cell.address.text = bookmark.shopAddress
        cell.distance.text = "\(00) mi"
        cell.rating.rating = bookmark.shopRating
    
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
//        if let shopProfileVC = storyboard.instantiateViewController(withIdentifier: "shopProfile") as? ShopProfileViewController {
//
//            let pseudoShop = bookmarks[indexPath.row]
//
//            let dummyShop = Shop(withId: pseudoShop.shopId, name: pseudoShop.shopName, status: "", longitude: pseudoShop.shopLongitude, latitude: pseudoShop.shopLatitude, zipCode: "", description: "", rating: Int(pseudoShop.shopRating), pictures: [pseudoShop.shopIcon])
//
//            shopProfileVC.shop = dummyShop
//        }
        
        if let shopNav = storyboard.instantiateViewController(withIdentifier: "shopProfileNavC") as? UINavigationController {
            
            let pseudoShop = bookmarks[indexPath.row]
            
            let latitude = pseudoShop.shopLatitude ?? 0.0
            let longitude = pseudoShop.shopLongitude ?? 0.0

            
            let dummyShop = Shop(withId: "\(pseudoShop.shopId)", name: pseudoShop.shopName, status: "", longitude: longitude, latitude: latitude , zipCode: "", description: "", rating: Int(pseudoShop.shopRating), pictures: [pseudoShop.shopIcon])
            
            // Instantiate shop profile to pass shop object/info
            let shopProfileVC = shopNav.topViewController as! ShopProfileViewController
//            shopProfileVC.shop = dummyShop
            
            
            self.present(shopNav, animated: true, completion: nil)
            
        }
        
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken") else {return}
            let bookmarkId = bookmarks[indexPath.row].shopId // en "withId:" va bookmarkId, NO indexPath.row
            DispatchQueue.global(qos: .userInitiated).async {
                 BookmarkMethods.removeBookmark(withId: indexPath.row, authToken: userAuthKey, completion: nil)
            }
            
            bookmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

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

    
    // MARK: - Load Data
    
    func loadDummyBookmarks(){
    
        let bm = Bookmark(shopId: 01, shopIcon: UIImage(named:"2")!, shopName: "The Shop", shopRating: 1.0, shopAddress: "John F. Street, #542", shopLongitude: 18.45323, shopLatitude: 19.343543)
        let bm2 = Bookmark(shopId: 01, shopIcon: UIImage(named:"2")!, shopName: "The X", shopRating: 3.3, shopAddress: "Churchill Street, #76", shopLongitude: 18.45323, shopLatitude: 19.343543)
        let bm3 = Bookmark(shopId: 01, shopIcon: UIImage(named:"2")!, shopName: "Nail Center", shopRating: 5.0, shopAddress: "Khe Street, #34", shopLongitude: 18.45323, shopLatitude: 19.343543)
        
        bookmarks = [bm, bm2, bm3]
        
    }
    
    func loadBookmarks() {
        
        guard let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken") else {return}
        
        BookmarkMethods.getAllBookmarksFrom(user: userAuthKey) { (bookmarks) in
            
            for bookmark in bookmarks {
                let id = bookmark.id
                let name = bookmark.name ?? ""
                let icon = UIImage(named: "5")!//bookmark.profilePicture.
                let rating = bookmark.rating ?? "0.0"
                let ratingDouble = Double(rating) ?? 0.0
                let address = bookmark.address ?? ""
                
                self.bookmarks.append(Bookmark(shopId: id, shopIcon: icon, shopName: name, shopRating: ratingDouble, shopAddress: address, shopLongitude: nil, shopLatitude: nil) )
            }
            
            DispatchQueue.main.async {
                self.bookmarkTableView.reloadData()
            }
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
