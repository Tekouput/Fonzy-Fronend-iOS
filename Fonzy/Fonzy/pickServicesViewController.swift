//
//  pickServicesViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/9/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit

class pickServicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellIdentifier = "serviceCell"
    var services = [Service]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadDummyServices()
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? serviceTableViewCell else{
            fatalError("KHEEEEEEEEE!!!!!")
        }
        
        let service = services[indexPath.row]
        
        cell.name.text = service.name //"Khe no"
        cell.price.text = "\(service.price)" //"US$ \(40)"
        cell.icon.image = service.icon! //UIImage(named: "2")
        cell.estimatedTime.text = "Time: \(service.estimatedTime) mins"
        //cell.addServiceButton.isHidden = false
        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadDummyServices(){
        // Here I will call the API to fetch shop services
        let service = Service(id: 01, icon: UIImage(named: "brush"), name: "Regular cut", price: 24.95, estimatedTime: 30.5, categoryName: "Cut", description: "Cut cut cut", statusName: "Available")
        let service2 = Service(id: 02, icon: UIImage(named: "brush"), name: "Extreme cut", price: 50, estimatedTime: 30.5, categoryName: "Cut", description: "Cut cut cut", statusName: "Available")
        let service3 = Service(id: 03, icon: UIImage(named: "brush"), name: "Nail care", price: 30.0, estimatedTime: 30.5, categoryName: "Nails", description: "Nails Nails", statusName: "Available")
        let service4 = Service(id: 04, icon: UIImage(named: "brush"), name: "Special cut", price: 24.95, estimatedTime: 70, categoryName: "Cut", description: "Cut cut cut", statusName: "Available")
        let service5 = Service(id: 05, icon: UIImage(named: "brush"), name: "Shave", price: 24.95, estimatedTime: 20, categoryName: "Cut", description: "Cut cut cut", statusName: "Available")
        
        services = [service, service2, service3, service4, service5]
        
    }
    
    @IBAction func unwindToPickServiceVC(segue: UIStoryboardSegue){
        //
    }

}
