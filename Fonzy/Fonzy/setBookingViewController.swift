//
//  setBookingViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/8/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
//import JTAppleCalendar

protocol HairdresserPicker {
    func picked(hairdresser: Hairdresser)
}

class setBookingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let reuseIdentifier = "hairdresserCell"
//    let formatter = DateFormatter()
    
    @IBOutlet weak var hairdresserCollectionView: UICollectionView!
    
    var hairdressers = [Hairdresser]()
//    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
      var pickedHairdresser = Hairdresser(Id: 01, name: "Ok", profilePicture: UIImage(named: "user")!)
    
    var delegate: HairdresserPicker?

    var service: Service?
    var shop: Store?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hairdresserCollectionView.delegate = self
        hairdresserCollectionView.dataSource = self
        

//        //
//        calendarCollectionView.delegate = self
//        calendarCollectionView.dataSource = self
        
        self.view.addSubview(hairdresserCollectionView)
//        self.view.addSubview(calendarCollectionView)
        
//        loadDummyHairdressers()
        loadHairdressers()
        
        if let serv = service {
            print("Service name: ", serv.name)
        }
        if let shp = shop {
            print("Shop name: ", shp.name)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
            // Configure the cell
            return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pickedHairdresser = hairdressers[indexPath.row]
        
delegate?.picked(hairdresser: pickedHairdresser)
    }
    
    

    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
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
        
        if let destination = segue.destination as? bookViewController {
            
            destination.service = service
            destination.pickedHairdresser = pickedHairdresser
            destination.shop = shop
        }
 
     }
    
    
}

//
//
//extension setBookingViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
//    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
//
//    }
//
//
////
////    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
////
////        guard let myCell = cell as? calendarCollectionViewCell else {
////            fatalError("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
////        }
////        myCell.dateLabel.text = cellState.text
////    }
////
//
//
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        formatter.dateFormat = "yyyy MM dd"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
//
//        let startDate = formatter.date(from: "2017 01 01")
//        let endDate = formatter.date(from: "2017 12 31")
//
//        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
//        return parameters
//
//    }
//
//
//    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt
//        date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
//
//        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! calendarCollectionViewCell
//
//        cell.dateLabel.text = cellState.text
//
//        return cell
//    }
//}
//

