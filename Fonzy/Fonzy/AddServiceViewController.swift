//
//  AddServiceViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 1/27/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SwiftKeychainWrapper

protocol AddService {
    func add(service: Service)
}

class AddServiceViewController: UIViewController {

    var delegate: AddService?
    @IBOutlet weak var serviceNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var serviceCategoryTextField: JVFloatLabeledTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var servicePriceTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var serviceEstimatedTimeTextField: JVFloatLabeledTextField!
    
    var shop: Store?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginViewController.dismissKeyboard)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func SaveButton(_ sender: Any) {
        
        // Check values
        if let name = serviceNameTextField.text, let price = Double(servicePriceTextField.text!),
            let estimatedTime = Double(serviceEstimatedTimeTextField.text!), let categoryName = serviceCategoryTextField.text {
            
            let newService = Service(id: 01, icon: nil, name: name, price: price, estimatedTime: estimatedTime, categoryName: categoryName, description: descriptionTextField.text!, statusName: "Active")
            
//            insertService()
            postNewService()
            
            delegate?.add(service: newService)
            self.dismiss(animated: true, completion: nil)
        }

        
    }

    
  /*  func insertService() {
        
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        
        let parameters =
        [
            "name":"\(serviceNameTextField.text!)",
            "description":"\(descriptionTextField.text!)",
            "price":"\(String(describing: Int(servicePriceTextField.text!)))",
            "duration":"\(ceil(Double(serviceEstimatedTimeTextField.text!)!)*60)"
        ]
        
        let link = Config.fonzyUrl + "users/services"
        guard let url = URL(string: link) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
     
        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        
        session.dataTask(with: request) {[weak self] (data, response, error) in
        
            if let data = data {
                
                do {
                    
                    let service = try? JSONDecoder().decode(JSONService.self, from: data)
                    print("HEEEY NEW SERVICE HERE: ", service)
                    
                } catch let err {
                    print("Error while parsing service",err)
                }
                
            }
            
            }.resume()
    }
*/
    @objc func dismissKeyboard() {
        serviceNameTextField.resignFirstResponder()
        serviceCategoryTextField.resignFirstResponder()
        servicePriceTextField.resignFirstResponder()
        serviceEstimatedTimeTextField.resignFirstResponder()
        
        descriptionTextField.resignFirstResponder()
        
    }
    
    func postNewService() {
        
        let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken")
        
        guard let shopId = shop?.id else {return}
        let link = Config.fonzyUrl + "stores/services"
        
        var url = URLComponents(string: link)!
        url.queryItems = [
            URLQueryItem(name: "id", value: "\(shopId)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        
      
        request.addValue(userAuthKey!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        guard let serviceName = serviceNameTextField.text else {return}
        guard let servicePriceText = servicePriceTextField.text else {return}
        guard let servicePriceNumber = Double(servicePriceText) else {return}
        guard let serviceTimeText = serviceEstimatedTimeTextField.text else {return}
        guard let serviceEstimatedTime = Int(serviceTimeText) else {return}
       let serviceDescription = descriptionTextField.text ?? ""
        
        let parameters = [
            "name": "\(serviceName)",
            "description": "\(serviceDescription)",
            "price": "\(servicePriceNumber)",
            "duration": "\(serviceEstimatedTime*60)"
        ]
      print("Services parameters: ", parameters)
       guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            print("SERVICE POST Response: ", response)
            guard let data = data else {return}
            
            
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
