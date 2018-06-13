//
//  ShopProfileViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 9/15/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import Cosmos
import SwiftKeychainWrapper

class ShopProfileViewController: UIViewController {
    
    var services = [Service]()
    
    var shop: Store?
    //Shop(withId: "00", name: "....", status: "..", longitude: 00.0, latitude: 00.0, zipCode: "00", description: "!", rating: 0, pictures: [UIImage(named: "fonzy")!,UIImage(named: "fonzy")!])
    
    var shopInfo: shopAllInfo?
    var shopImages: ShopImages?
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopRating: CosmosView!
    @IBOutlet weak var shopStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        shopName.text = shop?.name
        if let rating = shop?.ratings {
            if let doubleRating = Double(rating) {
                shopRating.rating = doubleRating
            }
        }
        shopStatus.text = "Open"
        
        shopImage.image = UIImage(named: "6")!
        
        
        loadShop()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadServices()
            self.loadShopImages()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindToShopProfile(segue: UIStoryboardSegue){
        
    }

    func loadDummyServices(){
        // Here I will call the API to fetch shop services
//        let service = Service(id: 01, icon: UIImage(named: "brush"), name: "Regular cut", price: 24.95, estimatedTime: 30.5, categoryName: "Cut", description: "Cut cut cut", statusName: "Available")
//        let service2 = Service(id: 02, icon: UIImage(named: "brush"), name: "Extreme cut", price: 50, estimatedTime: 30.5, categoryName: "Cut", description: "Cut cut cut", statusName: "Available")
//        let service3 = Service(id: 03, icon: UIImage(named: "brush"), name: "Nail care", price: 30.0, estimatedTime: 30.5, categoryName: "Nails", description: "Nails Nails", statusName: "Available")
//        let service4 = Service(id: 04, icon: UIImage(named: "brush"), name: "Special cut", price: 24.95, estimatedTime: 70, categoryName: "Cut", description: "Cut cut cut", statusName: "Available")
//        let service5 = Service(id: 05, icon: UIImage(named: "brush"), name: "Shave", price: 24.95, estimatedTime: 20, categoryName: "Cut", description: "Cut cut cut", statusName: "Available")
//
//        services = [service, service2, service3, service4, service5]
        
        
        
    }
    
    // Load real services
    func loadServices(){
        
        let link = Config.fonzyUrl + "stores/services"
        var url = URLComponents(string: link)!
        // Need to fetch user id from auth token + user + blahblah
        // TODO: modificarlo
        url.queryItems = [
            URLQueryItem(name: "id", value: "\((shop?.id)!)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
            
            if let data = data {
                
                print("dataaaaaa: ", data)
                print("respooonse: ", response)
                
                do{
                    let services = try? JSONDecoder().decode([JSONService].self, from: data)
                    print(services)
                    
                    if let services = services {
                        for serv in services {
                            self?.services.append(Service(id: serv.id, icon: nil, name: serv.name, price: Double(serv.price)!, estimatedTime: Double(serv.duration)!/60, categoryName: "Cuts", description: serv.description, statusName: "Active"))
                        }
                    }
                }catch let err{
                    
                }
                
            }
            }.resume()
        
    }
    
    func loadShop() {
        
        let shopId = (shop?.id)!
        let link = Config.fonzyUrl + "stores/all_info"
        guard var url = URLComponents(string: link) else {return}
        url.queryItems = [
        URLQueryItem(name: "store_id", value: "\(shopId)")
        ]
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession.shared
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            print("Shop all info response: ", response)
            if let data = data {
                do{
                    self?.shopInfo = try JSONDecoder().decode(shopAllInfo.self, from: data)
                } catch let err {
                    print("ERROR ON SHOP: ", err)
                }
                
            }
            }.resume()
        
    }
    

    
    func loadShopImages() {
        
        // http://54.244.57.51/stores/pictures?store_id=14
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        
        let linkUrl = Config.fonzyUrl + "stores/pictures"
        var url = URLComponents(string: linkUrl)!
        // Need to fetch user id from auth token + user + blahblah
        // TODO: modificarlo
        url.queryItems = [
            URLQueryItem(name: "store_id", value: "\((shop?.id)!)")
        ]
        
        var request = URLRequest(url: url.url!)

        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
            
            print("image response: ", response)
            
            guard let data = data else {return}
            
            do {
                self?.shopImages = try JSONDecoder().decode(ShopImages.self, from: data)
                print(self?.shopImages?.images.first)
            } catch let err {
                print("Error while parsing images: ", err)
            }
        }.resume()
        
    }
    
    
    // Save this shop to users bookmarks
    @IBAction func BookmarkBtnPressed(_ sender: Any) {
        
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        
        let link = Config.fonzyUrl + "users/bookmark/store"
        var url = URLComponents(string: link)
        url?.queryItems = [
            URLQueryItem(name: "entity_id", value: "\(shop?.id)")
        ]
        var request = URLRequest(url: (url?.url)!)
        request.httpMethod = "POST"
        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            guard let data = data else {return}
            
            print("Successfully inserted, id:", self.shop?.id ?? -1)
            print("Data: ", data)
            print("Respose: ", response)
            print("Error", err)
            
            }.resume()
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if let nextVC = segue.destination as? servicesTableViewController{
            nextVC.services = services
            nextVC.shop = shop
            nextVC.currentStoryboard = .main
//            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            if let imageUrl = shopImages?.main?.medium {
                    let url = URL(string: imageUrl)
                    let urlContents = try? Data(contentsOf: url!)
                    
                    if let imageData = urlContents {
//                        nextVC.shopImage = UIImage(data: imageData)
                        nextVC.shopImageData = imageData
                    }
                    
                }
//            }
            
        }
        
        // Send shopInfo to teams ViewController
        if let destination = segue.destination as? hairdresserTableViewController {
            destination.shopId = shop?.id
        }
        
        // Pass the selected object to the new view controller.
    }
 

}
