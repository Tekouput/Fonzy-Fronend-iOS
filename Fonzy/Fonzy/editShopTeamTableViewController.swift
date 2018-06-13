//
//  editShopTeamTableViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/9/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class editShopTeamTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hairdressersTableView: UITableView!
    let cellIdentifier = "hairdresserCell"
    var hairdressers = [Hairdresser]()
    var shopHairdressers: HairdresserShop?
    
    @IBOutlet weak var addHairdresser: UIButton!
    
    @IBOutlet weak var updateHairdressers: UIButton!

    var shop: Store?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        hairdressersTableView.delegate = self
        hairdressersTableView.dataSource = self
        
//        loadDummyHairdressers()
        loadHairdressers()

        
    }

    
    @IBAction func UpdateHairdressers(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
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
        return hairdressers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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


    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteHairdresser(withId: hairdressers[indexPath.row].Id)
            hairdressers.remove(at: indexPath.row)
            hairdressersTableView.deleteRows(at: [indexPath], with: .fade)
            
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


    
    /*
     func loadDummyHairdressers() {
        
        let h = Hairdresser(Id: 01, name: "John Doe", profilePicture: UIImage(named:"barberMan1")!)
        
        let h2 = Hairdresser(Id: 02, name: "Ian Maxwell", profilePicture: UIImage(named:"user")!)
        
        let h3 = Hairdresser(Id: 03, name: "Mary Jane", profilePicture: UIImage(named:"women")!)
        
        hairdressers = [h, h2, h3]
    }
     */
    
    func loadHairdressers() {
        
        guard let shopId = shop?.id else {return}
        
        let link = Config.fonzyUrl + "stores/hairdressers?store_id=\(shopId)"
        guard let url = URL(string: link) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            print("hairdressers response: ", response)
            guard let data = data else {return}
            do{
                
                //                self?.shopHairdressers
                let shopHairdressers = try JSONDecoder().decode(HairdresserShop.self, from: data)
                print(self?.shopHairdressers)
                
                for hairdresser in shopHairdressers {
                    
                    guard let hairdresserId = hairdresser.request.hairDresserID else {return}
                    
                    let profilePicture = self?.getHairdresserProfilePicture(withId: hairdresserId)
                    
                    let firstName = hairdresser.hairDresserUser.firstName ?? ""
                    let lastName = hairdresser.hairDresserUser.lastName ?? ""
                    
                    
                    self?.hairdressers.append(Hairdresser(Id: hairdresserId, name: "\(firstName) \(lastName)", profilePicture: profilePicture!))
                    DispatchQueue.main.async {
                        self?.hairdressersTableView.reloadData()
                    }
                }
            } catch let err {
                print("Heey error hairdresser: ", err)
            }
            
            
            }.resume()
        
        
        
    }
    
    func getHairdresserProfilePicture(withId hairdresserId: Int) -> UIImage {
        
        loadPublicProfile(with: hairdresserId, completion: { (publicProfile) in
            
            guard let hairdresser = publicProfile else {return UIImage(named: "user")!}
            guard let pictureUrl = hairdresser.profilePicture?.medium else {return UIImage(named: "user")!}
            
            let imgUrl = URL(string: pictureUrl)
            guard let imageUrl = imgUrl else {return UIImage(named: "user")!}
            let urlContents = try? Data(contentsOf: imageUrl)
            
            if let imageData = urlContents {
                if let image = UIImage(data: imageData) {
                    return image
                } else {
                    return UIImage(named: "user")!
                }
            } else {
                return UIImage(named: "user")!
            }
            
            
        })
        return UIImage(named: "user")!
    }
    
    func loadPublicProfile(with Id: Int, completion: @escaping ((UserAuth?) -> UIImage)) {
        
        var userPublicProfile: UserAuth?
        
        let link = Config.fonzyUrl + "users/profile?id=\(Id)"
        guard let url = URL(string: link) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {return}
            
            do {
                userPublicProfile = try JSONDecoder().decode(UserAuth.self, from: data)
                print("User public profile: ", userPublicProfile)
                completion(userPublicProfile)
            } catch let err {
                print("Error while parsing public profile: ", err)
            }
            
            }.resume()
        
    }
    
    
    func deleteHairdresser(withId id: Int) {
        
        if let userToken = KeychainWrapper.standard.string(forKey: "authToken") {
            
            guard let shopId = shop?.id else {return}
            
            let link = Config.fonzyUrl + "stores/hairdressers"
            var url = URLComponents(string: link)!
            
            url.queryItems = [
                URLQueryItem(name: "store_id", value: "\(shopId)"),
                URLQueryItem(name: "dresser_id", value: "\(id)")
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let destination = segue.destination as? addHairdresserViewController {
            destination.shop = shop
        }
     }
    
    
    
    
    

}
