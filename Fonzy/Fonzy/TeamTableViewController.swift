//
//  TeamTableViewController.swift
//  Fonzy
//
//  Created by fitmap on 2/9/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class TeamTableViewController: UITableViewController {

    @IBOutlet weak var hairdressersTableView: UITableView!
    let cellIdentifier = "hairdresserCell"
    var hairdressers = [Hairdresser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        hairdressersTableView.delegate = self
        hairdressersTableView.dataSource = self
        
        loadDummyHairdressers()
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
        return hairdressers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? hairdresserTableViewCell else {
            fatalError("Could not dequeue cell as hairdresserCell")
        }
        
        let hairdresser = hairdressers[indexPath.row]
        
        // Configure the cell...
        
        cell.profilePicture.image = hairdresser.profilePicture
        
        cell.name.text = hairdresser.name
        
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.bounds.size.width * 0.5
        cell.profilePicture.contentMode = .scaleAspectFill
        cell.profilePicture.clipsToBounds = true
        
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func loadDummyHairdressers() {
        
        let h = Hairdresser(Id: 01, name: "John Doe", profilePicture: UIImage(named:"barberMan1")!)
        
        let h2 = Hairdresser(Id: 02, name: "Ian Maxwell", profilePicture: UIImage(named:"user")!)
        
        let h3 = Hairdresser(Id: 03, name: "Mary Jane", profilePicture: UIImage(named:"women")!)
        
        hairdressers = [h, h2, h3]
        
    }
    
}
