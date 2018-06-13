//
//  notificationTableView.swift
//  Fonzy
//
//  Created by fitmap on 11/16/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class notificationTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {

        
    override func viewDidLoad() {
        super.viewDidLoad()
            
            // Uncomment the following
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let notifications = [Notification]()
    
    let cellIdentifier = "notificationCell"
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1//notifications.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? notificationTableViewCell else {
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        let notification = notifications[indexPath.row]
        
        cell.title.text = "khe"
        cell.descrip.text = "Ok"
        
        
        return cell
        
    }
    

}
