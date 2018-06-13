//
//  AddMyClientViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/10/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class AddMyClientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var clientsTableView: UITableView!
    
    var clients = [UserSearch]()
    let cellIdentifier = "clientCell"
    var searchController: UISearchController!
    var shop: Store?
    
    var filteredClients = [UserSearch]()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup the Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Hairdresser"
        clientsTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        // Do any additional setup after loading the view.
        clientsTableView.delegate = self
        clientsTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredClients.count
        } else {
            return clients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HairdresserSearchTableViewCell else {
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        let hairdresser: UserSearch
        if isFiltering() {
            hairdresser = filteredClients[indexPath.row]
        }else{
            hairdresser = clients[indexPath.row]
        }
        
        let firstName = hairdresser.firstName ?? "No name"
        let lastName = hairdresser.lastName ?? ""
        let address = hairdresser.address ?? "No address"
        
        cell.profilePicture.image = UIImage(named: "user") //look for that image with the appropiate method
        cell.name.text = firstName + " " + lastName
        cell.address.text = address
        
        
        cell.profilePicture.layer.cornerRadius = 0.5 * cell.profilePicture.bounds.size.width
        cell.profilePicture.contentMode = .scaleAspectFill
        cell.profilePicture.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let clientName = clients[indexPath.row].firstName ?? ""
        let alert = UIAlertController(title: "Add Client", message: "Would you like to add \(clientName) to Your Clients?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak self] action in
            
            self?.startActivityIndicator()
            DispatchQueue.global(qos: .userInitiated).async {
                self?.sendMyClientRequest(withId: (self?.clients[indexPath.row].id)!)
            }
            
        }))
        
        self.present(alert, animated: true)
    }
    
    
    /*
     * Get a client ID and link the client with the shop
     */
    func sendMyClientRequest(withId id: Int) {
        
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        guard let shopId = shop?.id else {return}

        
        let link = Config.fonzyUrl + "stores/clients"
        var url = URLComponents(string: link)!
        
        url.queryItems = [
            URLQueryItem(name: "store_id", value: "\(shopId)"),
            URLQueryItem(name: "user_id", value: "\(id)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            print("My client response: ", response)
            
            if let data = data {
                DispatchQueue.main.async {
                    self?.stopActivityIndicator()
                    
                    // Show confirmation alert
                    let alert = UIAlertController(title: "Client added", message: "Client inserted successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    
                }
            } else {
                DispatchQueue.main.async {
                    self?.stopActivityIndicator()
                    
                    // Show confirmation alert
                    let alert = UIAlertController(title: "Request failed", message: "An error occured, please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    
                }
            }
            
        }.resume()
        
    }
    
    
    // MARK: - Search bar methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        // Look for hairdressers
        
        searchClients(with: searchText)
        //        hairdresserTableView.reloadData()
        
        
        filteredClients = clients.filter({( hairdresser : UserSearch) -> Bool in
            let name = hairdresser.firstName ?? ""
            let lastName = hairdresser.lastName ?? ""
            let fullName = name + lastName
            return fullName.lowercased().contains(searchText.lowercased())
        })
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchClients(with userName: String) {
        
        let link = Config.fonzyUrl + "find/user?qv=\(userName)"
        guard let url = URL(string: link) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            print("Filtering users response : ", response)
            guard let data = data else {return}
            
            do{
                self?.clients = try JSONDecoder().decode([UserSearch].self, from: data)
                
                DispatchQueue.main.async {
                    self?.clientsTableView.reloadData()
                }
                
            } catch let err {
                print("Error while parsing filtered users: ", err)
            }
            
            }.resume()
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func startActivityIndicator() {
        //Setting up activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }

}


extension AddMyClientViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
