//
//  AdminShopPickerViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/9/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class AdminShopPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    var shopAdmin: Authenticate?
    @IBOutlet weak var shopsTableView: UITableView!
    let cellIdentifier = "shopCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        shopsTableView.delegate = self
        shopsTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = shopAdmin?.user.stores?.count {
            return count
        } else {
            return 0
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShopPickerTableViewCell else {
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        if let store = shopAdmin?.user.stores?[indexPath.row] {
            cell.shopProfilePicture.image = UIImage(named: "5")
            cell.shopName.text = store.name
            
            cell.shopProfilePicture.layer.cornerRadius = 0.5 * cell.shopProfilePicture.bounds.size.width
            cell.shopProfilePicture.contentMode = .scaleAspectFill
            cell.shopProfilePicture.clipsToBounds = true
        }
        

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name:"ShopOwner", bundle: nil)
        if let shopNVC = storyboard.instantiateViewController(withIdentifier: "shopOwnerInitialVC")  as? UINavigationController {
            if let initialShopViewController = shopNVC.viewControllers.first as? notificationsTableViewController {
                initialShopViewController.shopOwner = shopAdmin
                initialShopViewController.shop = shopAdmin?.user.stores?[indexPath.row]
            }
            
            self.present(shopNVC, animated: true, completion: nil)
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
