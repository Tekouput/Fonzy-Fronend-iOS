//
//  HairdresserScheduleViewController.swift
//  Fonzy
//
//  Created by fitmap on 1/30/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class HairdresserScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var hairdresserCollectionView: UICollectionView!
    let reuseIdentifier = "hairdresserCell"
    var hairdressers = [Hairdresser]()
    var pickedHairdresser: Hairdresser?
    var pickedServices = [Service]()
    
    var shop: Store?
    var shopOwner: Authenticate?

    
    var hasPickedHairdresser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hairdresserCollectionView.delegate = self
        hairdresserCollectionView.dataSource = self
    
//        loadDummyHairdressers()
        loadHairdressers()

    }

    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return hairdressers.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? hairdresserCollectionViewCell else {
            fatalError("Cannot deque cell to hairdresserCell")
        }
        
        let hairdresser = hairdressers[indexPath.row]
        
        cell.profilePicture.image = hairdresser.profilePicture
        cell.name.text = hairdresser.name
        
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.bounds.size.width * 0.5
        cell.profilePicture.clipsToBounds = true
        cell.profilePicture.contentMode = .scaleAspectFill
        

        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pickedHairdresser = hairdressers[indexPath.row]
    }

    @IBAction func NextButtonTapped(_ sender: Any) {
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if pickedHairdresser != nil { hasPickedHairdresser = true }
        
        if !hasPickedHairdresser {
            // Show confirmation alert
            let alert = UIAlertController(title: "Missing service", message: "A service needs to be selected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        return hasPickedHairdresser
    }
    
    
    func loadDummyHairdressers() {
        
        let h = Hairdresser(Id: 01, name: "John Doe", profilePicture: UIImage(named:"barberMan1")!)
        
        let h2 = Hairdresser(Id: 02, name: "Ian Maxwell", profilePicture: UIImage(named:"user")!)
        
        let h3 = Hairdresser(Id: 03, name: "Mary Jane", profilePicture: UIImage(named:"women")!)
        
        hairdressers = [h, h2, h3]
        
    }
    
    // MARK: - Hairdresser loading methods
    
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
                print(shopHairdressers)
                
                for hairdresser in shopHairdressers {
                    
                    guard let hairdresserId = hairdresser.request.hairDresserID else {return}
                    
                    let profilePicture = self?.getHairdresserProfilePicture(withId: hairdresserId)
                    
                    let firstName = hairdresser.hairDresserUser.firstName ?? ""
                    let lastName = hairdresser.hairDresserUser.lastName ?? ""
                    
                    
                    self?.hairdressers.append(Hairdresser(Id: hairdresserId, name: "\(firstName) \(lastName)", profilePicture: profilePicture!))
                    DispatchQueue.main.async {
                        self?.hairdresserCollectionView.reloadData()
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

     
        if let destinationVC = segue.destination as? ScheduleConfirmationViewController {
//            destinationVC.selectedHairdresser = hairdressers[(hairdresserCollectionView.indexPathsForSelectedItems?.first?.row)!]
            destinationVC.selectedHairdresser = pickedHairdresser
            destinationVC.pickedServices = pickedServices
            destinationVC.shop = shop
            destinationVC.shopOwner = shopOwner
        }
        

        
    }
    

}
