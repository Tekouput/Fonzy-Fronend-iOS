//
//  NotificationsViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 9/15/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NotificationsViewController: UITableViewController, IndicatorInfoProvider {

    @IBOutlet var notificationTableView: UITableView!
    let cellIdentifier = "notificationCell"
    var notifications = [Notification]()
    
    override func viewDidLoad() {
//        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        loadDummyNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? notificationTableViewCell else {
            fatalError("The dequeued cell is not an instance of notificationTableViewCell")
        }
        
        let notification = notifications[indexPath.row]
        
        cell.title.text = notification.title
        cell.descrip.text = notification.description
        
        return cell
        
    }
    

    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
    func loadDummyNotifications(){
        
        let notification = Notification(title: "Service Cancelled", description: "Your service has been cancelled due to bad weather")
        
        let notification2 = Notification(title: "Transfer complete", description: "Your service has been cancelled due to bad weather")
        
        let notification3 = Notification(title: "Ilegal report", description: "You have submitted an ilegal report")
        
        notifications = [notification, notification2, notification3]
        
    }
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Notifications")
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
