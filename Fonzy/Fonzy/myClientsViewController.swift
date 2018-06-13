//
//  myClientsViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/19/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

let identifier = "clientCell"

class myClientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddClient, UISearchResultsUpdating {

    var newUser = User(withId: 1, profilePic: UIImage(named: "user")!, firstName: ".", lastName: "..", phoneNumber: 00000, email: "..@test.com")
    var usr = User(withId: 2, profilePic: UIImage(named: "user")!, firstName: ".", lastName: "..", phoneNumber: 00000, email: "..@test.com")
    
    @IBOutlet weak var clientsTableView: UITableView!
    var myClients = [User]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredUsers = [User]()
    var shop: Store?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Clients"
        
        clientsTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        
        clientsTableView.delegate = self
        clientsTableView.dataSource = self
        
//        loadDummyMyClients()
        loadMyClients()
        
        

       
    }
    
    func add(user: User) {
        usr = user
        myClients.append(usr)
        clientsTableView.reloadData()
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
        if isFiltering(){
         return filteredUsers.count
        }
        return myClients.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? clientTableViewCell else {
            fatalError("Could not dequeue CLIENT table view cell")
        }

        let client: User
        if isFiltering(){
            client = filteredUsers[indexPath.row]
        }else{
            client = myClients[indexPath.row]
        }
        
//        cell.profilePic.image = client.profilePic
        cell.name.text = "\(client.firstName) \(client.lastName!)"
        cell.phoneNumber.text = "\(client.phoneNumber!)"
        cell.phoneIcon.image = UIImage(named: "phone")
        // Configure the cell...
        
//        cell.profilePic.image = client.profilePic?.resizeImageWith(newSize: CGSize(width: 60.0, height: 60.0) )

//        cell.profilePic.image = client.profilePic?.resizeImage(CGFloat(60) , opaque: false)
        
        cell.profilePic.image = client.profilePic!
        cell.profilePic?.contentMode = .scaleAspectFill
        cell.profilePic.backgroundColor = UIColor.clear
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height / 2
        cell.profilePic.clipsToBounds = true;

        
        return cell
    }
    
    
    
    func loadMyClients() {
        
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        guard let shopId = shop?.id else {return}
        
        let link = Config.fonzyUrl + "stores/clients"
        var url = URLComponents(string: link)!
        url.queryItems = [
            URLQueryItem(name: "store_id", value: "\(shopId)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        
        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            print("My Clients response: ", response)
            guard let data = data else {return}
            
            do {
                
                let myClients = try JSONDecoder().decode([MyClient].self, from: data)
                
                for client in myClients {
                    
                    let firstName = client.user.firstName ?? "No name"
                    let lastName = client.user.lastName ?? ""
                    let address = client.user.address ?? "No address"
                    
                    var profilePicture = UIImage(named: "user")!
                    // Load hairdresser profile picture
                    let imageString = client.user.profilePicture?.medium ?? ""
                    let imgUrl = URL(string: imageString)
                    if let imgUrl = imgUrl {
                        let urlContents = try? Data(contentsOf: imgUrl)
                        if let imageData = urlContents {
                            if let image = UIImage(data: imageData) {
                                profilePicture = image
                            }
                        }
                    }
                    
                    let usr = User(withId: client.id, profilePic: profilePicture, firstName: firstName, lastName: lastName, phoneNumber: Double(client.user.id), email: address)
                    
                    self?.myClients.append(usr)
                }
                
                DispatchQueue.main.async {
                    self?.clientsTableView.reloadData()
                }
                
            } catch let err {
                print("Error while parsing my Clients: ", err)
            }
            
        }.resume()
        
    }

    
    // Override to support conditional editing of the table view.
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            // Show confirmation alert
            let alert = UIAlertController(title: "Remove Client", message: "Are you sure you want to remove this client", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                if( self.isFiltering() ) {
                    self.removeMyClient(withId: self.filteredUsers[indexPath.row].id)
                    self.filteredUsers.remove(at: indexPath.row)
                } else {
                    self.removeMyClient(withId: self.myClients[indexPath.row].id)
                    self.myClients.remove(at: indexPath.row)
                }
                self.clientsTableView.deleteRows(at: [indexPath], with: .fade)


                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    func removeMyClient(withId id: Int) {
        
        if let userToken = KeychainWrapper.standard.string(forKey: "authToken") {
            
            guard let shopId = shop?.id else {return}
            
            let link = Config.fonzyUrl + "stores/clients"
            var url = URLComponents(string: link)!
            
            url.queryItems = [
                URLQueryItem(name: "store_id", value: "\(shopId)"),
                URLQueryItem(name: "client_id", value: "\(id)")
            ]
            var request = URLRequest(url: url.url!)
            request.httpMethod = "DELETE"
            request.addValue(userToken, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
                
                print("heeey response: ", response)
                print("Hey data: ",data)
                
                
                }.resume()
            
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
    
    
    // MARK: - Search bar methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredUsers = myClients.filter({( user : User) -> Bool in
//            let textToSearch = user.firstName + " " + user.lastName! + " " + "\(user.phoneNumber)"
            return  user.firstName.lowercased().contains(searchText.lowercased())
        })
        
        clientsTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    
    
    @IBAction func UpdateButtonTapped(_ sender: Any) {
        myClients.removeAll()
        loadMyClients()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? addClientViewController {
            destination.delegate = self
        }
        
        if let destination = segue.destination as? AddMyClientViewController {
            destination.shop = shop
        }
    
    }
    
    @IBAction func unwindToMyClients(segue: UIStoryboardSegue){
        //
    }
    
    
    
    
}






