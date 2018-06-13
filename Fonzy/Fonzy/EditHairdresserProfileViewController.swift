//
//  EditHairdresserProfileViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 1/28/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class EditHairdresserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstName: JVFloatLabeledTextField!
    
    @IBOutlet weak var lastName: JVFloatLabeledTextField!
    @IBOutlet weak var bio: JVFloatLabeledTextField!
    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var invokeCamera: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //TODO: display hairdresser info if available
        //Poner un hairdresser nil aquí, y que la vista que lo llame, en el prepare for segue, le setee el objeto de hairdresser
        
        
        // Dismiss keyboard on tap
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginViewController.dismissKeyboard)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Save(_ sender: Any) {
        
        // Save new hairdresser
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        bio.resignFirstResponder()
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
//        userImainge = image
        invokeCamera.setImage(image, for: .normal)
        invokeCamera.imageView?.layer.cornerRadius = invokeCamera.frame.width / 2
        invokeCamera.clipsToBounds = true
        invokeCamera.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
        
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
