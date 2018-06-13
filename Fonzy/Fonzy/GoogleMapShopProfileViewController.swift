//
//  GoogleMapShopProfileViewController.swift
//  Fonzy
//
//  Created by fitmap on 2/15/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class GoogleMapShopProfileViewController: UIViewController {

    var shop: GoogleMap?
    var shopMapInfo: ShopMapInfo?
    var shopMapImage: UIImage?
    
    @IBOutlet weak var mapShopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var isOpen: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadShopInfo()
        
        if let shop = shop {
            shopName.text = shop.name
            shopAddress.text = shop.vicinity
            if let openNow = shop.openingHours?.openNow {
                if openNow {
                    isOpen.text = "Open"
                } else {
                    isOpen.text = "Closed"
                    isOpen.textColor = UIColor.red
                }
            }
        }
        
        mapShopImage.contentMode = .scaleAspectFill
        mapShopImage.image = shopMapImage
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CallBtnPressed(_ sender: Any) {
        
        if let phoneNumber = shopMapInfo?.internationalPhoneNumber {
            
            var uc = URLComponents()
            uc.scheme = "tel"
            uc.path = "\(phoneNumber)"
            print(uc.url!)
            UIApplication.shared.open(uc.url!)
        } else {
            
            // Diplay no number alert
            let alert = UIAlertController(title: "No number", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            
            self.present(alert, animated: true)
            
        }
        
    }
    

    func loadShopInfo() {
    
        //http://54.244.57.51/stores?store_id=ChIJiRA5StyJr44RI7HbcofWqNA&maps=true
        
        let link = Config.fonzyUrl + "stores"
        var url = URLComponents(string: link)!
        
        url.queryItems = [
            URLQueryItem(name: "store_id", value: shop?.placeID),
            URLQueryItem(name: "maps", value: "true")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in

            guard let data = data else {return}
                print("DATA: ", data)
                print("RESPONSE: ", response)
            
                do {
                    self?.shopMapInfo = try JSONDecoder().decode(ShopMapInfo.self, from: data)
                    print("I'm shop info: ", self?.shopMapInfo)
                    print("My number is: ", self?.shopMapInfo?.internationalPhoneNumber)
                    
                } catch let err {
                    print("Error while parsing google maps info: ", err)
                }
            print("Error: ", err)
        }.resume()
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let shopDetail = shopMapInfo {
            if let destination = segue.destination as? InfoMapShopViewController {
                destination.shopMapInfo = shopDetail
            }
        }
    }
    

}
