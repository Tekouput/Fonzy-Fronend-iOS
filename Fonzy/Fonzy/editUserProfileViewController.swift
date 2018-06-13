//
//  editUserProfileViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/8/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import Photos
import JVFloatLabeledTextField
import SwiftKeychainWrapper

class editUserProfileViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var user: UserAuth?
    var usrSex = Sex.female
    var userProfilePicture: UIImage?


    
    @IBOutlet weak var userName: JVFloatLabeledTextField!
    @IBOutlet weak var userLastName: JVFloatLabeledTextField!
    @IBOutlet weak var userSex: JVFloatLabeledTextField!
    @IBOutlet weak var userBirthday: JVFloatLabeledTextField!
    @IBOutlet weak var userPhoneNumber: JVFloatLabeledTextField!
    @IBOutlet weak var userZipCode: JVFloatLabeledTextField!
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    var pickerOptions = ["Male", "Female", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        userName.delegate = self
        userLastName.delegate = self
        userSex.delegate = self
        userBirthday.delegate = self
        userPhoneNumber.delegate = self
        userZipCode.delegate = self
        
        // set name
        if let usr = user {
            let firstName = usr.firstName ?? ""
            let lastName = usr.lastName ?? ""
            
            userName.text = firstName
            userLastName.text = lastName
        }
        
        // set sex
        if usrSex == .female {
            userSex.text = "Female"
        } else if usrSex == .male {
            userSex.text = "Male"
        } else {
            userSex.text = "Other"
        }
        
        // Set birthdate
        if let birthdate = user?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
//            userBirthday.text = dateFormatter.string(from: birthdate)
            userBirthday.text = birthdate
        }
        
        // Set phone number
        if let phoneNumber = user?.phoneNumber {
            userPhoneNumber.text = phoneNumber
        }
        
        // Set zipCode
        if let zipCode = user?.address?.zipCode {
            userZipCode.text = zipCode
        }
        
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editUserProfileViewController.dismissKeyboard)))
        
        //Sex picker view
        let pickerView = UIPickerView()
        pickerView.delegate = self
        userSex.inputView = pickerView
        
        // Birthday picker view
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        userBirthday.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(editUserProfileViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        

        
        activityIndicator.hidesWhenStopped = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PickerView Methods
    
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
        userSex.text = pickerOptions[row]
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        
        userBirthday.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    // MARK: - TextField methods
    
    @objc func dismissKeyboard() {
        userName.resignFirstResponder()
        userLastName.resignFirstResponder()
        userSex.resignFirstResponder()
        userBirthday.resignFirstResponder()
        userPhoneNumber.resignFirstResponder()
        userZipCode.resignFirstResponder()
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
            print("Ok textfield")
        default:
            scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func SaveBtnTapped(_ sender: Any) {
        activityIndicator("Updating user")
        updateUserImage()
        updateUser()
    }
    
    func updateUser() {
        
        let firstName = userName.text ?? ""
        let lastName = userLastName.text ?? ""
        let birthday = userBirthday.text ?? ""
        let sex = userSex.text ?? "Other"
        let zipCode = userZipCode.text ?? ""
        let phoneNumber = userPhoneNumber.text ?? ""
        
        let user = JSONUser(firstName: firstName, lastName: lastName, birthDate: birthday, sex: sex, zip: zipCode, phoneNumber: phoneNumber)
        
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
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, response, error) in
            
            if let data = data{
                print(data)
                do{
                    // check this deserlization, date objects are causing errors (createdAt and updatedAt)
                    let decoder = JSONDecoder()
                    //                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    DispatchQueue.main.async {
                        self?.stopActivityIndicator()
                    }
                    self?.performSegue(withIdentifier: "unwindToUserProfile", sender: self)

                    let newUser = try decoder.decode(JSONUser2.self, from: data)
                    print("HEEEEY NEW USER: \(newUser.firstName)!!!!!")
                    
                    
                }catch let jsonErr{
                    print("KKKKKKKKKK", jsonErr)
                }
                DispatchQueue.main.async {
                    self?.stopActivityIndicator()
                }
            }
            }.resume()
        
        
    }
    
    @IBAction func ChangeProfilePictureButtonTapped(_ sender: Any) {
        
        checkPermission()

        
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let cameraOption = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
                
            }
            
        })
        
        let libraryOption = UIAlertAction(title: "Photo library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                var photoPicker = UIImagePickerController()
                photoPicker.delegate = self
                photoPicker.sourceType = .photoLibrary
                photoPicker.allowsEditing = true
                self.present(photoPicker, animated: true, completion: nil)
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        // 4
        optionMenu.addAction(cameraOption)
        optionMenu.addAction(libraryOption)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            userProfilePicture = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func updateUserImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken") else {return}
            
            if let profilePicture = self.userProfilePicture {
                ImageMethods.saveUserProfilePicture(image: profilePicture, withToken: userAuthKey, completion: nil)
            }
        }
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized: print("Access is granted by user")
        case .notDetermined: PHPhotoLibrary.requestAuthorization({
            
            (newStatus) in
            print("status is \(newStatus)")
            if newStatus == PHAuthorizationStatus.authorized {  print("success") }
        })
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
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
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        effectView.removeFromSuperview()
    }
    
}
