//
//  bookingsTableViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/8/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class bookingsTableViewController: UITableViewController {

    let cellIdentifier = "bookingCell"
    @IBOutlet var bookingsTableView: UITableView!
    
    var bookings = [Booking]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        loadDummyBooking()
        loadBookings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? myBookingTableViewCell else{
            //Print/"handle" error
            fatalError("The dequeued cell is not an instance of shoptableViewCell")
        }
        
        let booking = bookings[indexPath.row]

        // Configure the cell...

        cell.service.text = booking.serviceName!
        cell.dateTime.text = "15/09/2017 05:30 PM"
        cell.barberShop.text = booking.shopName!
        cell.address.text = booking.address!
        cell.status.text = booking.statusName!
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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


    
    // MARK: - Load Data
    
    func loadDummyBooking(){
        
        let b = Booking(serviceName: "Haircut", statusName: "Active", date: Date(), address: "John F. Kennedy St.", longitude: 19.564343, latitude: 18.8654, shopId: 01, shopName: "The Shop", hairdresserId: 01, hairdresserName: "John Doe")
        
        let b2 = Booking(serviceName: "Nail Care", statusName: "Cancelled", date: Date(), address: "Churchill St.", longitude: 19.534343, latitude: 18.8654, shopId: 02, shopName: "The X", hairdresserId: 01, hairdresserName: "Marie Doe")
        
        
        let b3 = Booking(serviceName: "Haircut", statusName: "Active", date: Date(), address: "John F. Kennedy St.", longitude: 19.564343, latitude: 18.8654, shopId: 01, shopName: "The Shop", hairdresserId: 01, hairdresserName: "John Doe")
        
        
        bookings = [b,b2,b3]
    }
    
    
    func loadBookings() {
        
        //        JSONBooking
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        
        let link = Config.fonzyUrl + "users/bookings/"
        let url = URL(string: link)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
            
            print("All user bookings response: ", response)
            
            guard let data = data else {return}
            
            do {
                
                let bookings = try JSONDecoder().decode([JSONBooking].self, from: data)
                print("Cantidad de bookings: ", bookings.count)
                
                for booking in bookings {
                    if let bookDate = booking.bookDate {
                    
                        let serviceName = booking.service.name
                        let bookingState = "\(booking.state)"
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        guard let stringBookDate = booking.bookDate else {return}
                        guard let bookingDate = dateFormatter.date(from: stringBookDate) else {
                            fatalError("ERROR: Date conversion failed due to mismatched format.")
                        }
                        
                        let city = booking.handler.info?.address?.city ?? ""
                        let state = booking.handler.info?.address?.state ?? ""
                        let street = booking.handler.info?.address?.address[0].shortName ?? ""
                        let bookingAddress = "\(street), \(city), \(state)"
                        guard let handlerId = booking.handler.info?.id else {return}
                        
                        let handlerFirstName = booking.handler.info?.firstName ?? ""
                        let handlerLastName = booking.handler.info?.lastName ?? ""
                        let handlerName = "\(handlerFirstName) \(handlerLastName)"
                        
                        self?.bookings.append(Booking(serviceName: booking.service.name, statusName: "\(booking.state)", date: bookingDate, address: bookingAddress, longitude: nil, latitude: nil, shopId: handlerId, shopName: handlerName, hairdresserId: handlerId, hairdresserName: handlerName)  )
                    }
                }
            } catch let err {
                print("Error while parsing user bookings: ", err)
            }
            
            DispatchQueue.main.async {
                self?.bookingsTableView.reloadData()
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

}
