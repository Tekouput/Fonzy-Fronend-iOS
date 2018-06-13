//
//  notificationsTableViewController.swift
//  Fonzy
//
//  Created by fitmap on 11/16/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class notificationsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var notificationsTableView: UITableView!
    var notifications = [Notification]()
    let cellIdentifier = "notificationCell"
    @IBOutlet weak var scheduleShortcutButton: UIButton!
    
    var shopOwner: Authenticate?
    var shop: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        
        //Customize shortcut button
        scheduleShortcutButton.layer.cornerRadius = 5
        
        
        if(UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        {
            loadInitialNotifications();
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        //Set table view background image
        let backgroundImage = UIImage(named: "6");
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        notificationsTableView.backgroundView = backgroundImageView
        notificationsTableView.allowsSelection = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? notificationTableViewCell else {
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        
        
        //If it's not the first time user is in app
        if !(UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        {
            let notification = notifications[indexPath.row]

        cell.title.text = notification.title
        cell.descrip.text = notification.description
        }
        
        return cell
        
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
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
        
        if let destination = segue.destination as? adminShopProfileViewController {
            destination.shop = shop
            destination.shopOwner = shopOwner
        }
        
        if let destination = segue.destination as? myClientsViewController {
            destination.shop = shop
        }
        
        if let destination = segue.destination as? HamburguerMenuViewController {
            destination.shop = shop
        }
        
        if let destination = segue.destination as? ServicePickerViewController {
            destination.shop = shop
            destination.shopOwner = shopOwner
        }
        
    }
    
    
    func loadInitialNotifications(){
        notifications.append(Notification(title: "WELCOME!", description: "This is you live feed of updates") )
        notifications.append(Notification(title: "FONZY TIPS", description: "Tap to view or swipe left to dismiss"))
         notifications.append(Notification(title: "FONZY TIPS", description: "Add you card and accept online payment"))
    }
    
    @IBAction func unwindToShopAdminMainViewNotificationsViewController(segue: UIStoryboardSegue){
        //
    }
    
    

}
