//
//  addHairdresserViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/10/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class addHairdresserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hairdresserTableView: UITableView!
    
    var hairdressers = [UserSearch]()
    let cellIdentifier = "hairdresserCell"
    var searchController: UISearchController!
    var shop: Store?
    
    var filteredHairdressers = [UserSearch]()

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Setup the Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Hairdresser"
        hairdresserTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        // Do any additional setup after loading the view.
        hairdresserTableView.delegate = self
        hairdresserTableView.dataSource = self
        
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
            return filteredHairdressers.count
        } else {
            return hairdressers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HairdresserSearchTableViewCell else {
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        let hairdresser: UserSearch
        if isFiltering() {
            hairdresser = filteredHairdressers[indexPath.row]
        }else{
            hairdresser = hairdressers[indexPath.row]
        }
        
        let firstName = hairdresser.firstName ?? "No name"
        let lastName = hairdresser.lastName ?? ""
        let address = hairdresser.address ?? "No address"

        cell.profilePicture.image = UIImage(named: "user") //look for that image with the appropiate method
        cell.name.text = firstName + lastName
        cell.address.text = address
        
        
        cell.profilePicture.layer.cornerRadius = 0.5 * cell.profilePicture.bounds.size.width
        cell.profilePicture.contentMode = .scaleAspectFill
        cell.profilePicture.clipsToBounds = true
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let hairdresserName = hairdressers[indexPath.row].firstName ?? ""
        let alert = UIAlertController(title: "Add Hairdresser", message: "Would you like to add \(hairdresserName) as a hairdresser?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak self] action in
            
            self?.startActivityIndicator()
            DispatchQueue.global(qos: .userInitiated).async {
                self?.sendHairdresserRequest(withId: (self?.hairdressers[indexPath.row].id)!)
                
            }
            
        }))
        
        self.present(alert, animated: true)
    }
    
    func sendHairdresserRequest(withId id: Int) {
        
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        guard let shopId = shop?.id else {return}
        
        // add hairdresser
        // http://54.244.57.51/stores/hairdressers?store_id=8&dresser_id=10
        
        let link = Config.fonzyUrl + "stores/hairdressers"
        var url = URLComponents(string: link)!
        
        url.queryItems = [
            URLQueryItem(name: "store_id", value: "\(shopId)"),
            URLQueryItem(name: "dresser_id", value: "\(id)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "PUT"
        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            print("Response posting hairdresser: ", response)
            
            print(data)
            if let data = data {
                DispatchQueue.main.async {
                    self?.stopActivityIndicator()
                    
                    // Show confirmation alert
                    let alert = UIAlertController(title: "Request sent", message: "A request has been made to hairdresser", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    
                }
            } else {
                
            }
           
            
        }.resume()
        
        
//        self?.stopActivityIndicator()
        
    }
    
    // MARK: - Search bar methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        // Look for hairdressers
    
        searchHairdressers(with: searchText)
//        hairdresserTableView.reloadData()

        
        filteredHairdressers = hairdressers.filter({( hairdresser : UserSearch) -> Bool in
            let name = hairdresser.firstName ?? ""
            let lastName = hairdresser.lastName ?? ""
            let fullName = name + lastName
            return fullName.lowercased().contains(searchText.lowercased())
        })
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchHairdressers(with userName: String) {
        
        let link = Config.fonzyUrl + "find/user?qv=\(userName)"
        guard let url = URL(string: link) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            print("Filtering users response : ", response)
            guard let data = data else {return}
            
            do{
                self?.hairdressers = try JSONDecoder().decode([UserSearch].self, from: data)
                
                DispatchQueue.main.async {
                    self?.hairdresserTableView.reloadData()
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


extension addHairdresserViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
}



