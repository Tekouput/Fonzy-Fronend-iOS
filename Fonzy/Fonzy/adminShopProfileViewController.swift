//
//  adminShopProfileViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 9/19/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class adminShopProfileViewController: UIViewController {

    var shopOwner: Authenticate?
    var shop: Store?
    var services = [Service]()
    
    @IBOutlet weak var editShopInfo: UIButton!
    @IBOutlet weak var shopProfileImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        editShopInfo.layer.cornerRadius = editShopInfo.bounds.size.width * 0.5
        
        editShopInfo.clipsToBounds = true
        
        if let shop = shop {
            shopProfileImage.image = UIImage(named: "shopChair")
            shopName.text = shop.name
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.loadServices()
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToadminShop(segue: UIStoryboardSegue){
        
        
    }

    func loadShopImages() {
        
    }
    
    // Load real services
    func loadServices(){
        
        let link = Config.fonzyUrl + "stores/services"
        var url = URLComponents(string: link)!
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
    
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? servicesTableViewController {
            destination.services = services
            destination.shop = shop
            destination.currentStoryboard = .shopOwner
        }
        
        if let destination = segue.destination as? shopInfoViewController {
            destination.shopInfo = shop
            destination.shopOwnerInfo = shopOwner
        }
        
        if let destination = segue.destination as? RatingViewController {
            if let rating = shop?.ratings {
                destination.shopRating = Double(rating)
            }
        }
        
        if let destination = segue.destination as? hairdresserTableViewController {
            destination.shopId = shop?.id
        }
        
        if let destination = segue.destination as? UINavigationController {
            if let shopEditVC = destination.viewControllers.first as? editShopProfileViewController {
                shopEditVC.shop = shop
            }
        }
    }
    

}
