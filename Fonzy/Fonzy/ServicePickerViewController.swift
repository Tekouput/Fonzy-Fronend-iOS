//
//  ServicePickerViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 1/29/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit

class ServicePickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var servicesTableView: UITableView!
    var services = [Service]()
    var pickedServices = [Service]()
    let cellIdentifier = "serviceCell"
    var shop: Store?
    var shopOwner: Authenticate?

    
    var hasPickedServices = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        servicesTableView.delegate = self
        servicesTableView.dataSource = self
        servicesTableView.allowsMultipleSelection = true
//        loadDummyServices()
        loadServices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return services.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? QuickServiceTableViewCell else {
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        let service = services[indexPath.row]
        
        cell.icon.image = UIImage(named: "boxUnchecked")
        cell.name.text = service.name
        cell.price.text = "$\(service.price) - \(service.estimatedTime)MIN"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let currentCell = tableView.cellForRow(at: indexPath) as? QuickServiceTableViewCell {
            currentCell.icon.image = UIImage(named: "boxChecked")
        }
        pickedServices.append(services[indexPath.row])
         hasPickedServices = true
        
    }

    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if let currentCell = tableView.cellForRow(at: indexPath) as? QuickServiceTableViewCell {
            currentCell.icon.image = UIImage(named: "boxUnchecked")
        }
        // TO-DO: remove correctly those unchecked services, because indexPath.row will return a different number
//        pickedServices.remove(at: indexPath.row)
        return indexPath
    }
    
    @IBAction func NextButtonTapped(_ sender: Any) {
        if pickedServices.count < 1 { hasPickedServices = false }
        
        if !hasPickedServices {
            // Show confirmation alert
            let alert = UIAlertController(title: "Missing service", message: "A service needs to be selected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return hasPickedServices
    }
    
    /*
     func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
     if let currentCell = tableView.cellForRow(at: indexPath) as? QuickServiceTableViewCell {
     if currentCell.isSelected {
     currentCell.icon.image = UIImage(named: "boxUnchecked")
     }
     }
     return indexPath
     }
     
     */
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        cell.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func loadDummyServices(){
        
        services.append(Service(id: 01, icon: nil, name: "Haircut", price: 23.99, estimatedTime: 40.0, categoryName: "Cuts", description: "Cut your hair!", statusName: "Active") )
        
        services.append(Service(id: 02, icon: nil, name: "Women's cut", price: 40.0, estimatedTime: 70.0, categoryName: "Rock your hair", description: "Cut your hair!", statusName: "Active") )
        
        services.append(Service(id: 01, icon: nil, name: "Kid's cut", price: 20.00, estimatedTime: 30.0, categoryName: "Cuts", description: "Polish you kid!", statusName: "Active") )
        
    }
    
    // Load real services
    func loadServices(){
        
        let link = Config.fonzyUrl + "stores/services"
        var url = URLComponents(string: link)!
        guard let shopId = shop?.id else {return}
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
                        DispatchQueue.main.async {
                            self?.servicesTableView.reloadData()
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
        
        if let destination = segue.destination as? HairdresserScheduleViewController {
            destination.pickedServices = pickedServices
            destination.shop = shop
            destination.shopOwner = shopOwner
        }
    }
    

}
