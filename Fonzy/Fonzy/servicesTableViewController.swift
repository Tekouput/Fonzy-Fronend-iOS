//
//  servicesTableViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/17/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

enum Storyboards {
    case main
    case shopOwner
}

class servicesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var servicesTableView: UITableView!
    @IBOutlet weak var shopProfileImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    
    
    let cellIdentifier = "serviceCell"
    
    var services = [Service]()
    var shop: Store?
    var shopImage: UIImage?
    var shopImageData: Data?
    var currentStoryboard: Storyboards?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        servicesTableView.delegate = self
        servicesTableView.dataSource = self
        
        if let shop = shop {
            
            shopName.text = shop.name
            if let imageData = shopImageData {
                 shopProfileImage.image = UIImage(data: imageData)
            } else {
                shopProfileImage.image = UIImage(named: "5")
            }
           
        }
        
        servicesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return services.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? serviceTableViewCell else{
            fatalError("KHEEEEEEEEE!!!!!")
        }
        
        let service = services[indexPath.row]
        
        cell.name.text = service.name //"Khe no"
        cell.price.text = "\(service.price)" //"US$ \(40)"
        cell.icon.image = UIImage(named: "2")! //service.icon!
        cell.estimatedTime.text = "Time: \(service.estimatedTime) mins"
        //cell.addServiceButton.isHidden = false
        
        // Configure the cell...

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if currentStoryboard == .main {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //        let bookingVC = storyboard.instantiateViewController(withIdentifier: "setBookingVC") as! setBookingViewController
            
            if let bookingNVC = storyboard.instantiateViewController(withIdentifier: "bookingNavigationController") as? BookingNavigationViewController {
                
                if let bookingVC = bookingNVC.viewControllers.first as? setBookingViewController {
                    bookingVC.service = services[indexPath.row]
                    bookingVC.shop = shop
                }
                
                self.present(bookingNVC, animated: true, completion: nil)
            }
            
            
            
        }
        
    }

    /*
    func goToSetBooking(sender: UIButton!){
        
        print("!!!!!!!!WHAT'S UP!!!!!!!!!!!!!!!")
        
    }
    */
    
    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToServicesTableView(segue: UIStoryboardSegue){
        //
    }

}
