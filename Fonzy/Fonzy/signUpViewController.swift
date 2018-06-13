//
//  signUpViewController.swift
//  
//
//  Created by Jhonny Bill Mena on 8/20/17.
//
//

import UIKit
import SwiftKeychainWrapper


struct JSONHairdresser: Codable {
    let user: JSONUser
    let hairdresserInfo: Independent
    
    enum CodingKeys: String, CodingKey {
        case user
        case hairdresserInfo = "hairdresser_info"
    }
}

struct HairdresserNew: Codable {
    let isIndependent: Bool
    let longitude, latitude: String
    let description: String
    let onlinePayment, state: Bool
    let timeTable: TimeTable?
    
    enum CodingKeys: String, CodingKey {
        case isIndependent = "is_independent"
        case longitude, latitude, description
        case onlinePayment = "online_payment"
        case state
        case timeTable = "time_table"
    }
}

class signUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var birthdayTextField: UITextField!
    @IBOutlet var sexTextField: UITextField!

    @IBOutlet var isHairdresserButton: UIButton!
    @IBOutlet var isShopOwnerButton: UIButton!
    @IBOutlet var isCustomerButton: UIButton!
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var pickerOptions = ["Male", "Female", "Other"]
    
     var user = JSONUser(firstName: "", lastName: "", birthDate: "2018-02-13", sex: "Male", zip: "10602", phoneNumber: "232932323")
    
    let pickerView = UIPickerView()
    let datePickerView: UIDatePicker = UIDatePicker()

    var userSex: String = ""
    var userRole = Role.customer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        
        
        nameTextField.underlined()
        nameTextField.underlined()
        lastNameTextField.underlined()
        birthdayTextField.underlined()
        sexTextField.underlined()
        emailTextField.underlined()
        passwordTextField.underlined()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpViewController.dismissKeyboard)))

        
        pickerView.delegate = self as! UIPickerViewDelegate
        sexTextField.inputView = pickerView
        
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        birthdayTextField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(signUpViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var isCustomer = true
    var isHairdresser = false
    var isShopOwner = false
    
    
    @IBAction func isHairdresser(_ sender: Any) {
        
        
        if isHairdresser {
            isHairdresserButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isHairdresser = false
        }else{
            isHairdresserButton.setImage(UIImage(named: "boxCheckedWhite"), for: .normal)
            isShopOwnerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isCustomerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isHairdresser = true
            isShopOwner = false
            isCustomer = false
            userRole = .hairdresser
        }
    }
    
    @IBAction func isShopOwner(_ sender: Any) {
        
        if isShopOwner {
            isShopOwnerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isShopOwner = false
        }else{
            isShopOwnerButton.setImage(UIImage(named: "boxCheckedWhite"), for: .normal)
            isHairdresserButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isCustomerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isShopOwner = true
            isCustomer = false
            isHairdresser = false
            
            userRole = .shopOwner
        }
    }
    
    @IBAction func isCustomer(_ sender: Any) {
        
        if isCustomer {
            isCustomerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isCustomer = false
        }else{
            isCustomerButton.setImage(UIImage(named: "boxCheckedWhite"), for: .normal)

            isShopOwnerButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isHairdresserButton.imageView?.image = UIImage(named: "boxUncheckedWhite")
            isCustomer = true
            isShopOwner = false
            isHairdresser = false
            
            userRole = .customer
        }
    }
    
    
    
    ///////
   
    @IBAction func pickBirthday(_ sender: UITextField) {
        
//        let datePickerView:UIDatePicker = UIDatePicker()
//        
//        datePickerView.datePickerMode = UIDatePickerMode.date
//        
//        sender.inputView = datePickerView
//        
//        datePickerView.addTarget(self, action: #selector(signUpViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        birthdayTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    //////
    
    @IBAction func sexPicker(_ sender: UITextField) {
        
//        let pickerView = UIPickerView()
//        pickerView.delegate = self as! UIPickerViewDelegate
//        sexTextField.inputView = pickerView
        
    }
    
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
        sexTextField.text = pickerOptions[row]
        userSex = pickerOptions[row]
    }
    
    
    @objc func dismissKeyboard() {
        nameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        birthdayTextField.resignFirstResponder()
        sexTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...2:
            print("ok")
        default:
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
        
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func unwindToSignUp(segue: UIStoryboardSegue){
        //
    }
    

    @IBAction func ContinueButtonTapped(_ sender: Any) {
        
//        if isCustomer {
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            self.present(storyboard.instantiateViewController(withIdentifier: "fonzyHomeViewController"), animated: true, completion: nil)
//        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let passwordConfirmation = passwordTextField.text!
        
        postUser(email: email, password: password, passwordConfirmation: passwordConfirmation)
        
        
    }
    

    
    func postUser(email: String, password: String, passwordConfirmation: String){
        
        DispatchQueue.main.async {
            self.activityIndicator("Creating user")
        }
        
        let parameters = ["email":"\(email)","password":"\(password)","password_confirmation":"\(passwordConfirmation)"]
        
        let urlString = Config.fonzyUrl + "users"
        
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                    // login user
                    self?.loginUser(email: email, password: password)
                    
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        

    }
    

    
    func loginUser(email: String, password: String){
        
        let parameters = ["email":"\(email)","password":"\(password)"]
        
        let urlString = Config.fonzyUrl + "authenticate"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    if let key = json["auth_token"] as? String{
                        _ = KeychainWrapper.standard.set(key, forKey: "authToken")
                        print("WHAT WHAAAAAT????")
                        defer{
                            self.updateUser()
                        }
                    }
                    
                    print(json)
                    
                } catch {
                    print(error)
                }
                
            }
            
        }.resume()

        // Prepare user to save
        
        // Pick from
        DispatchQueue.main.async {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let date = dateFormatter.string(from: self.datePickerView.date)
            
            
            self.user = JSONUser(firstName: self.nameTextField.text!, lastName: self.lastNameTextField.text!, birthDate: date, sex: self.userSex, zip: "", phoneNumber: "")
        }
        
        
    }
    
    func updateUser(){
        
        let link = Config.fonzyUrl + "users"
        guard let url = URL(string: link) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        
        if let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken"){
            
            request.addValue(userAuthKey, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
        }
        let body = try? JSONEncoder().encode(user)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let data = data {
                print(data)
                do{
                    // check this deserlization, date objects are causing errors (createdAt and updatedAt)
                    let decoder = JSONDecoder()
                    //                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let newUser = try decoder.decode(UserAuth.self, from: data)
                    print("HEEEEY NEW USER: \(newUser.firstName)!!!!!")
                    
                    DispatchQueue.main.async {
                        
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let VC = storyboard.instantiateViewController(withIdentifier: "shopPickerViewController") as! shopPickerViewController
                        
                        self?.activityIndicator.stopAnimating()
                        self?.effectView.removeFromSuperview()
                        
                        
                        if (self?.isCustomer)! {
                            
                            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                            self?.present(storyboard.instantiateViewController(withIdentifier: "fonzyHomeViewController"), animated: true, completion: nil)
                            
                        } else if (self?.isShopOwner)!{
                            

                            VC.userRole = .shopOwner
                            self?.present(VC, animated: true, completion: nil)
                            
                        } else if (self?.isHairdresser)! {
                            
                            // PATCH hairdresser here
//                            self?.createHairdresser()

                            VC.userRole = .hairdresser
                            self?.present(VC, animated: true, completion: nil)
                            
                        }
                    }
                    
                }catch let jsonErr{
                    print("KKKKKKKKKK", jsonErr)
                }
                
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.effectView.removeFromSuperview()
                }
            }
            }.resume()
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !(identifier == "toShopPickerSegue")
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? shopPickerViewController{
           destination.userRole = userRole
            /* if isShopOwner {
                destination.userRole = .shopOwner
            }
            else if isHairdresser {
                destination.userRole = .hairdresser
            }
            else{
                destination.userRole = .customer
            } */
        }
        

        
    }

    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    

}
