//
//  loginViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 8/16/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

struct Usr: Decodable {
    
    let id: Int?
    let firstName: String?
    let lastName: String?
    let birthday: Date?
    let sex: String?
    let zipcode: String?
    let profilePic: String?
    let email: String?
    let password: String?
    let phoneNumber: Double?
    let stripeID: Double?
    let isShopOwner: String?
    let password_digest: String?
    /*let created_at: Double?
     let updated_at: Double?
     let uuid: String?
     let provider: String?
     let last_location: Double?
     */
}

class loginViewController: UIViewController {
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    var userAuthKey: String = "" {
        didSet {
            _ = KeychainWrapper.standard.set(userAuthKey, forKey: "authToken")
        }
    }
    
    var usr: Authenticate?
    var userRole: Role?
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        fonzyLogoImage.animationImages = [UIImage(named:"2")!, UIImage(named:"1")!]
        //        fonzyLogoImage.animationDuration = 5
        //        fonzyLogoImage.startAnimating()
        //        self.view.backgroundColor = UIColor.brown//.init(colorLiteralRed: 222, green: 184, blue: 135, alpha: 0.5)
        emailTextField.underlined()
        passwordTextField.underlined()
        loginButton.layer.cornerRadius = 8
    
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginViewController.dismissKeyboard)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    

    
    @IBAction func loginButtonPressed(_ sender: Any) {

        // authLogin2(email: "johndemo@test.com", password: "test1234"
        // authLogin2(email: "shop@test.com", password: "test1234"
        //authLogin2(email: "user2@test.com", password: "test1234"
        // email:  emailTextField.text!, password: passwordTextField.text!
        
        DispatchQueue.main.async {
            self.startActivityIndicator()
        }
        
        authLogin2(email:  emailTextField.text!, password: passwordTextField.text!, completion: { [weak self] in
            
            DispatchQueue.main.async {
                
                if self?.userRole != nil {
                    if self?.userRole == .customer {
                        self?.loginCustomer()
                    } else if self?.userRole == .shopOwner {
                        self?.loginShopOwner()
                    } else if self?.userRole == .multipleShopOwner {
                        self?.loginMultipleShopOwner()
                    }
                }  else {
                    
                }
            }
        })
        
        
    }
    
    
    func authLogin2(email: String, password: String, completion: (() -> ())?) {
        
        
        let parameters = ["email":"\(email)","password":"\(password)"]
        
        let urlString = Config.fonzyUrl + "authenticate"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
//                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    
                    self?.usr = try decoder.decode(Authenticate.self, from: data)
                    _ = KeychainWrapper.standard.set((self?.usr?.authToken)!, forKey: "authToken")
                    
                    let shopQuantity = self?.usr?.user.stores?.count ?? 0
                    
                    if shopQuantity < 1 {
                        self?.userRole = .customer
                    } else {
                        if shopQuantity > 1 {
                            self?.userRole = .multipleShopOwner
                        } else {
                            self?.userRole = .shopOwner
                        }
                    }
                    
//                    DispatchQueue.main.async {
//                        self?.stopActivityIndicator()
//                    }
                    
                    completion?()
                    
                } catch let err {
                    print("Error while log in: ", err)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Wrong username or password", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    }
                }
                
                DispatchQueue.main.async {
                    self?.stopActivityIndicator()
                }
            }
            
            }.resume()
    }
    
    
    
    func loginShopOwner(){
        
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
            
            if let shopOwnerNVC = storyboard.instantiateViewController(withIdentifier: "shopOwnerInitialVC") as? UINavigationController {
                if let notificationsVC = shopOwnerNVC.viewControllers.first as? notificationsTableViewController {
                    notificationsVC.shop = self?.usr?.user.stores?.first
                }
                self?.present(shopOwnerNVC, animated: true, completion: nil)
            }
            
        }
    }
    
    func loginCustomer(){
        
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let customerNVC = storyboard.instantiateViewController(withIdentifier: "fonzyHomeViewController") as? UINavigationController {
                if let fonzyHomeVC = customerNVC.viewControllers.first as? FonzyHomeViewController {
                    fonzyHomeVC.user = self?.usr
                }
                self?.present(customerNVC, animated: true, completion: nil)

            }
            
                
//                customerVC!.usr = self?.usr
            
            
        }
        
    }
    
    func loginMultipleShopOwner() {
        
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
            
            if let shopOwnerVC = storyboard.instantiateViewController(withIdentifier: "adminShopPickerViewController")  as? AdminShopPickerViewController {
                
                shopOwnerVC.shopAdmin = self?.usr
                self?.present(shopOwnerVC, animated: true, completion: nil)
                
            }
        }
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


    }
    
    
}
//
//extension UITextField{
//    
//    func underlined(){
//        let border = CALayer()
//        let width = CGFloat(1.0)
//        border.borderColor = UIColor.lightGray.cgColor
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
//        border.borderWidth = width
//        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
//    }
//}
