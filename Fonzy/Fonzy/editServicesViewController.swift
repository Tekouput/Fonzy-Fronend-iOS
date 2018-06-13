//
//  editServicesViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/9/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class editServicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddService {

    
    
    @IBOutlet weak var servicesTableView: UITableView!
    let cellIdentifier = "serviceCell"
    var services = [Service]()
    var shop: Store?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        loadServices()
    }
    
    func add(service: Service) {
        services.append(service)
        print(service.name)
        servicesTableView.reloadData()
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
        return services.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let service = services[indexPath.row]
        
        
        cell.textLabel?.text = service.name

        
        /*guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? serviceTableViewCell else{
            fatalError("KHEEEEEEEEE!!!!!")
        }
        
        let service = services[indexPath.row]
        
        cell.name.text = service.name //"Khe no"
        cell.price.text = "\(service.price)" //"US$ \(40)"
        cell.icon.image = service.icon! //UIImage(named: "2")
        cell.estimatedTime.text = "Time: \(service.estimatedTime) mins"
        //cell.addServiceButton.isHidden = false
        */
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let bookingVC = storyboard.instantiateViewController(withIdentifier: "setBookingVC") as! setBookingViewController
        //
        //        let bookingNVC = storyboard.instantiateViewController(withIdentifier: "bookingNavigationController")
        //
        //        self.present(bookingNVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
         deleteService(withId: services[indexPath.row].id)
        services.remove(at: indexPath.row)
        servicesTableView.deleteRows(at: [indexPath], with: .fade)
       
    }
    
    func deleteService(withId id: Int) {
        
        if let userToken = KeychainWrapper.standard.string(forKey: "authToken") {
            
            guard let shopId = shop?.id else {return}
        
        let link = Config.fonzyUrl + "stores/services"
        var url = URLComponents(string: link)!
        
        url.queryItems = [
            URLQueryItem(name: "service_id", value: "\(id)"),
            URLQueryItem(name: "id", value: "\(shopId)")
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
        if let destination = segue.destination as? AddServiceViewController {
            destination.delegate = self
            destination.shop = shop
        }
     }
 
    
    func loadServices(){
        
        guard let shopId = shop?.id else {return}
        let link = Config.fonzyUrl + "stores/services"
        var url = URLComponents(string: link)!
        // Need to fetch user id from auth token + user + blahblah
        // TODO: modificarlo
        url.queryItems = [
            URLQueryItem(name: "id", value: "\(shopId)")
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
                    DispatchQueue.main.async {
                        self?.servicesTableView.reloadData()
                    }
                }catch let err{
                    
                }
                
            }
        }.resume()
        
    }
    
    
    @IBAction func UpdateServices(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     var url = URLComponents(string: "http://54.244.57.51/stores/area")!
     url.queryItems = [
     URLQueryItem(name: "latitude", value: "\(userLocation.coordinate.latitude)"),
     URLQueryItem(name: "longitude", value:  "\(userLocation.coordinate.longitude)"),
     URLQueryItem(name: "distance_break", value: "\(radius)"),
     URLQueryItem(name: "style", value: shopType)
     ]
     
     var request = URLRequest(url: url.url!)
     request.httpMethod = "GET"
     
     URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
     
     guard let data = data else {return}
     do{
 */
    
    @IBAction func unwindToPickServiceVC(segue: UIStoryboardSegue){
        //
    }
}

