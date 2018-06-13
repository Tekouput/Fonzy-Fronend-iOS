//
//  bookViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/19/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class bookViewController: UIViewController, HairdresserPicker {


    @IBOutlet weak var bookButton: UIButton!
    
    @IBOutlet weak var hairdresserNameLabel: UILabel!
    @IBOutlet weak var hairdresserProfilePic: UIImageView!
    
    @IBOutlet weak var appointmentHour: UILabel!
    @IBOutlet weak var lastAppointmentLabel: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var servicePrice: UILabel!
    
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var totalAmountLabel: UILabel!
    var pickedTime: String?
   
    
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var cashButton: UIButton!
    var isCashSelected = true
    
    var pickedHairdresser: Hairdresser?//(Id: 01, name: "Ok", profilePicture: UIImage(named: "user")!)
    var shop: Store?
    var service: Service?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let price = self.service?.price ?? 0.0
        totalAmountLabel.text = "US$\(price)"
        
        bookButton.layer.cornerRadius = bookButton.bounds.size.width * 0.5
        bookButton.clipsToBounds = true
        
        //
        if let service = service {
            serviceName.text = service.name
            servicePrice.text = "US$\(service.price)"
        }
        if let hairdresser = pickedHairdresser {
            hairdresserNameLabel.text = hairdresser.name
            hairdresserProfilePic.image = hairdresser.profilePicture
        }
        if let bookingDate = BookingSelected.date {
            var dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            appointmentHour.text = "\(dateFormatter.string(from: bookingDate))"
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookViewController.dismissKeyboard)))

    }
    
    
    @IBAction func TipTextFieldDidEndEditing(_ sender: Any) {
        
        guard let service = service else {return}
        guard let tip = Double(tipTextField.text!) else {return}
        
        totalAmountLabel.text = "US$\(service.price + tip)"
    }
    
    @objc func dismissKeyboard() {
        tipTextField.resignFirstResponder()
    }
    

    func picked(hairdresser: Hairdresser) {
        pickedHairdresser = hairdresser
        
        
        bookButton.layer.cornerRadius = bookButton.bounds.size.width * 0.5
        
        hairdresserProfilePic.image = pickedHairdresser?.profilePicture
        hairdresserProfilePic.layer.cornerRadius = hairdresserProfilePic.bounds.size.width * 0.5
        hairdresserProfilePic.contentMode = .scaleAspectFill
        hairdresserProfilePic.clipsToBounds = true
        
        hairdresserNameLabel.text = pickedHairdresser?.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var isCardSelected = false
    @IBAction func PaymentButtonTapped(_ sender: Any){
        if let buttonTapped = sender as? UIButton {
            if isCardSelected {
                if buttonTapped.tag == 1 {
                    isCardSelected = false
                    cashButton.setImage(UIImage(named: "circleChecked"), for: .normal)
                    cardButton.setImage(UIImage(named: "circleUnchecked"), for: .normal)
                }
            }else{
                if buttonTapped.tag == 2 {
                    isCardSelected = true
                    cashButton.setImage(UIImage(named: "circleUnchecked"), for: .normal)
                    cardButton.setImage(UIImage(named: "circleChecked"), for: .normal)
                }
            }
            
        }
    }
    
    @IBAction func bookButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Booking confirmation", message: nil, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Confirm yor mobile number here"
            textField.keyboardType = UIKeyboardType.phonePad
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let number = alert.textFields?.first?.text {
                if let phoneNumber = Double(number) {
                    print("Your number: \(number)")
                    
                    // Call the insert book method
                    self.insertBooking()
                    
                } else {
                    
                }
            }
        }))
        
        self.present(alert, animated: true)
        
    }
    
    func insertBooking() {
        
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        guard let serviceId = service?.id else {return}
        guard let shopId = shop?.id else {return}
        
        guard let bookingDate = BookingSelected.date else {return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let date = dateFormatter.string(from: bookingDate)
         let bookTime = 3600//pickedTime else {return}
        
        let link = Config.fonzyUrl + "users/bookings/new"
        var url = URLComponents(string: link)!
        
//        url.queryItems = [
//            URLQueryItem(name: "entity_id", value: "\(shopId)"),
//            URLQueryItem(name: "service_id", value: "\(serviceId)"),
//            URLQueryItem(name: "book_time", value: "\(3600)"),
//            URLQueryItem(name: "book_notes", value: "Nothing to say"),
//            URLQueryItem(name: "book_date", value: date),
//            URLQueryItem(name: "type", value: "hairdresser")
//        ]
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")

        
        let bookingParameters =
            [
                "entity_id": "\(shopId)",
                "service_id": "\(serviceId)",
                "book_time": "\(bookTime)",
                "book_notes": "Nothing to say",
                "book_date": "\(date)",
                "type": "hairdresser"
            ]
        
        
        print("Parameters: ", bookingParameters)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: bookingParameters, options: []) else {return}
        
        print("Body: ", httpBody)
      
        request.httpBody = httpBody
        
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
            
            print("insert booking response: ", response)
            print("insert booking data: ", data)
            
            guard let data = data else {return}
            
            let alert = UIAlertController(title: "Thanks for booking!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initVC = storyboard.instantiateViewController(withIdentifier: "fonzyHomeViewController")
                
                self?.present(initVC, animated: true, completion: nil)
                
            }))
            self?.present(alert, animated: true)
            
           
            
        }.resume()
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if let destination = segue.destination as? setBookingViewController {
            destination.delegate = self
        }
    }
    

}
