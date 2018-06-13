//
//  editImagesViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/9/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class editImagesViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    
    let cellIdentifier = "imageCell"
    var shopImages: [UIImage] = []
    var logoImage: UIImage? = nil
    @IBOutlet weak var invokeCamera: UIButton!
    @IBOutlet weak var invokePhotoLibrary: UIButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var logoButton: UIButton!
    @IBOutlet weak var shopNameTextFIeld: JVFloatLabeledTextField!
    @IBOutlet weak var punchlineTextField: JVFloatLabeledTextField!
    var isLogo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      
        
        invokeCamera.layer.cornerRadius = 0.5 * invokeCamera.bounds.size.width
        invokeCamera.clipsToBounds = true
        
        invokePhotoLibrary.layer.cornerRadius = 0.5 * invokePhotoLibrary.bounds.size.width
        invokePhotoLibrary.clipsToBounds = true
        
        
        shopImages.append(UIImage(named: "2")!)
        
        
        // Customize logo button
        logoButton.backgroundColor = .clear
        logoButton.layer.cornerRadius = logoButton.bounds.size.width * 0.5
        logoButton.layer.borderWidth = 1
        logoButton.layer.borderColor = UIColor.gray.cgColor
        
        
       
        logoButton.imageView?.layer.cornerRadius = logoButton.bounds.size.width * 0.5
        logoButton.clipsToBounds = true
//        logoButton.imageView?.contentMode = .scaleAspectFill
 
        
        
        
        // Dismiss keyboard on tap
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(loginViewController.dismissKeyboard)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func invokeCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    
    @IBAction func invokePhotoLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = true
            self.present(photoPicker, animated: true, completion: nil)
        }
        
        let khe = sender as? UIButton
        
        if let a = khe?.tag {
            if a == 1 {
                isLogo = true
            }else{
                isLogo = false
            }
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Take my image
        if isLogo {
            logoImage = image
            logoButton.setImage(image, for: .normal)
            logoButton.imageView?.layer.cornerRadius = logoButton.frame.width / 2
            logoButton.clipsToBounds = true
//            logoButton.imageView?.contentMode = .scaleAspectFill
        }
        
        shopImages.append(image)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! shopPictureCollectionViewCell
        
        let image = shopImages[indexPath.row]
        
        cell.shopImage.image = image
        
        return cell
        
    }
    
    
    @IBAction func updateShopImages(_ sender: Any) {
        
    }
    
    
    // Dismiss keyboard on tap
    @objc func dismissKeyboard() {
        shopNameTextFIeld.resignFirstResponder()
        punchlineTextField.resignFirstResponder()
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
