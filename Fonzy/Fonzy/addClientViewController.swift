//
//  addClientViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/19/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

protocol AddClient {
    func add(user: User)
}


class addClientViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate {

    var newClient = User(withId: 1, profilePic: UIImage(named: "user")!, firstName: "Test", lastName: "Test", phoneNumber: 123456789, email: "test@test.com")
    var delegate: AddClient?
    var userImage = UIImage(named: "user")!
    
    @IBOutlet weak var firstName: JVFloatLabeledTextField!
    @IBOutlet weak var lastName: JVFloatLabeledTextField!
    @IBOutlet weak var email: JVFloatLabeledTextField!
    @IBOutlet weak var phoneNumber: JVFloatLabeledTextField!
    @IBOutlet weak var invokeCamera: UIButton!
    @IBOutlet weak var clientSearchBar: UISearchBar!

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addClientViewController.dismissKeyboard)))

        // Setup the Search Controller
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Clients"
//
        
    }
    
    @IBAction func invokeCamera(_ sender: Any) {
        
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 2
        let cameraOption = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in

            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
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
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Take my image
        userImage = image
        invokeCamera.setImage(image, for: .normal)
        invokeCamera.imageView?.layer.cornerRadius = invokeCamera.frame.width / 2
        invokeCamera.clipsToBounds = true
        invokeCamera.imageView?.contentMode = .scaleAspectFill

        dismiss(animated: true, completion: nil)
        
    }

    
    @objc func dismissKeyboard() {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        email.resignFirstResponder()
        phoneNumber.resignFirstResponder()
    }
    
    @IBAction func addNewClient(_ sender: Any) {
        
        
        newClient.firstName = firstName.text!
        newClient.lastName = lastName.text!
        if case newClient.email! = email.text! {
            newClient.email = email.text
        }
        newClient.phoneNumber = Double(phoneNumber.text!)
        newClient.profilePic = userImage
        
        delegate?.add(user: newClient)
        
        let storyboard = UIStoryboard(name: "ShopOwner", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "myClientsViewController") as! myClientsViewController
        
        performSegue(withIdentifier: "unwindToMyClients", sender: self)

        
        
        
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
