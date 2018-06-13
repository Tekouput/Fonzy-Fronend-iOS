//
//  addShopViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/2/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import CoreLocation
import JVFloatLabeledTextField
import SwiftKeychainWrapper

struct JSONShop: Codable {
    let id: Int
    let ownerID: Int
    let name: String
    let longitude: Double
    let latitude: Double
    let zipCode: String
    let description: String
    let createdAt: Date?
    let updatedAt: Date?
    let ratings: Int?
    let ownerType: String?
    let timeTable: String?
    let placeID: Int?
    let style: String
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownerID = "owner_id"
        case name = "name"
        case longitude = "longitude"
        case latitude = "latitude"
        case zipCode = "zip_code"
        case description = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ratings = "ratings"
        case ownerType = "owner_type"
        case timeTable = "time_table"
        case placeID = "place_id"
        case style = "style"
        case address = "address"
    }
}

struct PostShop: Codable {
    let name, longitude, latitude, zipCode: String?
    let description, timeTable, style: String?
    
    enum CodingKeys: String, CodingKey {
        case name, longitude, latitude
        case zipCode = "zip_code"
        case description
        case timeTable = "time_table"
        case style
    }
}

enum Style: String {
    case barberShop = "hair_care"
    case beautySalon = "beauty_salon"
    case independent = "independent"
}


class addShopViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    

    var userRole = Role.shopOwner
    var shopLocation: CLLocationCoordinate2D?
    var shopPhoneNumber: Double?
    var shopStyle: Style?
    var pickerOptions = ["Barber Shop", "Beauty Salon", "Independent"]

    
    @IBOutlet weak var shopNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var addressTextField: JVFloatLabeledTextField!
    @IBOutlet weak var zipCodeTextField: JVFloatLabeledTextField!
    @IBOutlet weak var shopStyleTextField: JVFloatLabeledTextField!
    @IBOutlet weak var shopDescriptionTextField: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        shopStyleTextField.inputView = pickerView

        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addClientViewController.dismissKeyboard)))
        
    }
    
    // MARK: - Style Picker Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        shopStyleTextField.text = pickerOptions[row]
        
        switch row {
        case 0:
            shopStyle = .barberShop
            break
        case 1:
            shopStyle = .beautySalon
            break
        default:
            shopStyle = .independent
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addShopDONEButton(_ sender: Any) {
        
        var style = "hair_care"
        if shopStyle == .beautySalon {
            style = "beauty_salon"
        }
        // TO FIX:
//        Parece que en maps si no muevo el pin no me toma un location?
        let parameters = [
            "name": "\((shopNameTextField?.text)!)",
            "longitude": "\((shopLocation?.longitude)!)",
            "latitude": "\((shopLocation?.latitude)!)",
            "zip_code": "\((zipCodeTextField?.text)!)",
            "description": "\((shopDescriptionTextField?.text)!)",
            "time_table": nil,
            "style": style
        ]
    
//        let postShop = PostShop(name: shopNameTextField?.text!, longitude: "\(String(describing: shopLocation?.longitude))", latitude: "\(String(describing: shopLocation?.latitude))", zipCode: , description: , timeTable: nil, style: style)
        
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        
        let link = Config.fonzyUrl + "stores"
        guard let url = URL(string: link) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
//        let httpBody = try? JSONEncoder().encode(postShop)
        
        request.httpBody = httpBody
        let session = URLSession.shared
        
        session.dataTask(with: request) {[weak self] (data, response, error) in
            if let data = data {
                
                do {
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    
                    let newShop = try? decoder.decode(JSONShop.self, from: data)
                    print("HEEEY NEW SHOP HERE: ", newShop)
                    
                } catch let err {
                    print("Error while parsing new Shop",err)
                }

                
            }
        
        }.resume()
        
    }
    
    @objc func dismissKeyboard() {
        shopNameTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        zipCodeTextField.resignFirstResponder()
        shopStyleTextField.resignFirstResponder()
        shopDescriptionTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? createShopViewController {
            if let shopName = shopNameTextField.text {
                destination.name = shopName
            }
        }
    }
    
    
    @IBAction func unwindToAddShopVC(segue: UIStoryboardSegue){
    }

}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
