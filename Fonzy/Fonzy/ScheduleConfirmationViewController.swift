//
//  ScheduleConfirmationViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 1/29/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftKeychainWrapper

class ScheduleConfirmationViewController: UIViewController {
    
    
    var selectedHairdresser: Hairdresser?
    var pickedServices = [Service]()
    var shop: Store?
    var shopOwner: Authenticate?

    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var hairdresserProfilePicture: UIImageView!
    
    @IBOutlet weak var fullNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var emailTextField: JVFloatLabeledTextField!
    @IBOutlet weak var phoneTextField: JVFloatLabeledTextField!
    @IBOutlet weak var notesTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var hairdresserButton: UIButton!
    @IBOutlet weak var servicesButton: UIButton!
    @IBOutlet weak var timeTextField: JVFloatLabeledTextField!
    @IBOutlet weak var paymentLabel: UILabel!
    
    @IBOutlet weak var cashButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    
    @IBOutlet weak var bookButton: UIButton!
    
    
    let dateFormatter = DateFormatter()
    let locale = NSLocale.current
    var datePicker : UIDatePicker!
    var pickedDate: String?
    var pickedTime: String?
    let toolBar = UIToolbar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Add buttons borders
        servicesButton.layer.borderColor = UIColor.black.cgColor
        servicesButton.layer.borderWidth = 1
        servicesButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        
        paymentLabel.layer.borderColor = UIColor.black.cgColor
        paymentLabel.layer.borderWidth = 1
        
        hairdresserButton.layer.borderColor = UIColor.black.cgColor
        hairdresserButton.layer.borderWidth = 1
        hairdresserButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        
        //Dismiss keyboard on tap
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ScheduleConfirmationViewController.dismissKeyboard)))
        
        
        
        
        // Configuring TIME "button" = TextField
        timeTextField.tintColor = UIColor.clear
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        timeTextField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ScheduleConfirmationViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        
        // Setting hairdresser imgs?
        hairdresserProfilePicture.image = selectedHairdresser?.profilePicture
        hairdresserProfilePicture.layer.cornerRadius = hairdresserProfilePicture.bounds.size.width * 0.5
        hairdresserProfilePicture.clipsToBounds = true
        hairdresserProfilePicture.contentMode = .scaleAspectFill
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set hairdresser picture
        
    }
    
    @IBAction func HairdresserBtnTapped(_ sender: Any) {
        
    }
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        timeTextField.text = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        pickedDate = dateFormatter.string(from: sender.date)
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        let hour = (components.hour! * 60) * 60
        let minute = (components.minute! * 60 )
        pickedTime = "\(hour + minute)"
        
        
        //        birthdayTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func BookBtnTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Booking confirmation", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
            
            
            DispatchQueue.main.async {
                self?.startActivityIndicator()
            }
            
            
            
            self?.createBooking(completion: {
                
                let alert = UIAlertController(title: "Thanks for booking!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] action in
                    
                    
                    
                    let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
                    if let initVC = storyboard.instantiateViewController(withIdentifier: "shopOwnerInitialVC") as? UINavigationController {
                        if let VC = initVC.viewControllers.first as? notificationsTableViewController {
                            VC.shop = self?.shop
//                            VC.shopOwner = shopOwner
                        }
                        
                        self?.present(initVC, animated: true, completion: nil)

                    }
                    
                }))
                self?.present(alert, animated: true)
                
                
            })
            
            
            
            
        }))
        
        self.present(alert, animated: true)
    }
    //    store_id=8&service_id=8&book_time=3600&book_notes=Hello&book_date=2018-03-11&email=&first_name=&last_name=&phone_number=&user_id=13
    
    func createBooking(completion: (() -> ())?) {
        
        guard let userToken = KeychainWrapper.standard.string(forKey: "authToken") else {return}
        
        guard let shopId = shop?.id else {return}
        guard let serviceId = pickedServices.first?.id else {return}
        guard let bookDate = pickedDate else {return}
        guard let bookTime = pickedTime else {return}
        
        let fullName = fullNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let notes = notesTextField.text ?? ""
        
        var link = Config.fonzyUrl + "stores/bookings"
        
        var url = URLComponents(string: link)!
        
        url.queryItems = [
            URLQueryItem(name: "store_id", value: "\(shopId)"),
            URLQueryItem(name: "service_id", value: "\(serviceId)"),
            URLQueryItem(name: "book_time", value: bookTime),
            URLQueryItem(name: "book_notes", value: notes),
            URLQueryItem(name: "book_date", value: bookDate),
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "first_name", value: fullName),
            URLQueryItem(name: "last_name", value: ""),
            URLQueryItem(name: "phone_number", value: phone),
            URLQueryItem(name: "user_id", value: "")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.addValue(userToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
            
            print("heeey response: ", response)
            print("Hey data: ",data)
            guard let data = data else {return}
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
            }
            completion?()
            //            do {
            ////                let bookings = try JSONDecoder().decode([JSONBooking].self, from: data)
            //                DispatchQueue.main.async {
            //                    self?.stopActivityIndicator()
            //                }
            //            } catch let err {
            //                print("Error while parsing booking: ", err)
            //                DispatchQueue.main.async {
            //                    self?.stopActivityIndicator()
            //                }
            //            }
            
            }.resume()
    }
    
    @objc func dismissKeyboard() {
        timeTextField.resignFirstResponder()
        fullNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        notesTextField.resignFirstResponder()
    }
    
    func startActivityIndicator() {
        //Setting up activity indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
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
