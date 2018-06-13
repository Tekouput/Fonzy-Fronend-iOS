//
//  createShopViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/7/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import Photos
import JVFloatLabeledTextField
import SwiftKeychainWrapper


struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "kyleleeheadiconimage234567.jpg"
        
        guard let data = UIImageJPEGRepresentation(image, 0.7) else { return nil }
        self.data = data
    }
    
}

typealias Parameters = [String: String]

class createShopViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var name = ""
    var punchline = ""
    var shopImages: [UIImage] = []
    
    @IBOutlet weak var invokeCamera: UIButton!
    @IBOutlet weak var invokePhotoLibrary: UIButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var shopName: JVFloatLabeledTextField!
    @IBOutlet weak var shopPunchline: JVFloatLabeledTextField!
    @IBOutlet weak var firstImageView: UIImageView!
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        invokeCamera.layer.cornerRadius = 0.5 * invokeCamera.bounds.size.width
        invokeCamera.clipsToBounds = true
        
        invokePhotoLibrary.layer.cornerRadius = 0.5 * invokePhotoLibrary.bounds.size.width
        invokePhotoLibrary.clipsToBounds = true
        
        
//        shopImages.append(UIImage(named: "2")!)
        
        shopName.text = name
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createShopViewController.dismissKeyboard)))

        firstImageView.contentMode = .scaleToFill
        
        activityIndicator.hidesWhenStopped = true
        checkPermission()
    }

    
    @IBAction func invokeCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = .overFullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func invokePhotoLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = true
            
            photoPicker.modalPresentationStyle = .overFullScreen
            self.present(photoPicker, animated: true, completion: nil)
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
    
    var isFirstPicture = true
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        

        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            //Take my image
            if isFirstPicture {
                
                firstImageView = UIImageView(image: pickedImage)
                shopImages.append(pickedImage)
                isFirstPicture = false
            } else {
                let shopImagesCount = shopImages.count
                if shopImagesCount < 4 {
                    shopImages.append(pickedImage)
                    imagesCollectionView.reloadData()
                }else{
                    shopImages.append(pickedImage)
                    imagesCollectionView.reloadData()
                    shopImages.remove(at: 0)
                }
            }
            
        }
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
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! shopPictureCollectionViewCell
        
        let image = shopImages[indexPath.row]
        
        cell.shopImage.image = image
        cell.shopImage.contentMode = .scaleAspectFill
        
        return cell
        
    }
    
    @IBAction func BeginButtonTapped(_ sender: Any) {
        
        activityIndicator("Saving image")
        guard let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken") else {return}
        
        if shopImages.count > 0 {
            
            ImageMethods.saveHairdresser(image: shopImages[0], withToken: userAuthKey, completion: {
                
                // Stop indicator
                print("image successfully inserted")
                
            })
            
        } else {
            
        }
        
        // Stop indicator
        self.stopActivityIndicator()
        
        // Get shop and present shopOwnerView
    
        ShopMethods.getFirstShopFromToken { (store) in
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard(name:"ShopOwner", bundle: nil)
                if let shopOwnerNVC = storyboard.instantiateViewController(withIdentifier: "shopOwnerInitialVC") as? UINavigationController,
                    let shopOwnerInitialVC = shopOwnerNVC.viewControllers.first as? notificationsTableViewController {
                    
                    shopOwnerInitialVC.shop = store
                    
                    self.present(shopOwnerNVC, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    @objc func dismissKeyboard() {
        shopName.resignFirstResponder()
        shopPunchline.resignFirstResponder()
    }
    
    
    @IBAction func unwindToCreateShop(segue: UIStoryboardSegue){
        //
    }

    
/*
    func saveShopImages() {
        
        var user: Authenticate?
        
        guard let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken") else {return}
        
        let parametersLogin = ["email":"prueba9@test.com","password":"test1234"] //STATIONARY
        
        guard let loginUrl = URL(string: "http://54.244.57.51/authenticate") else {return}
        var loginRequest = URLRequest(url: loginUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametersLogin, options: []) else {return}
        
        loginRequest.httpBody = httpBody
        
        let loginSession = URLSession.shared
        loginSession.dataTask(with: loginRequest) { (data, response, error) in
            
            if let data = data {
                
                do {
                    user = try JSONDecoder().decode(Authenticate.self, from: data)
                    _ = KeychainWrapper.standard.set((user?.authToken)!, forKey: "authToken")
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        
        
        /*
        */
        
        
        let link = Config.fonzyUrl + "stores/pictures"
         var url = URLComponents(string: link)!
        
//        url.queryItems = [
//            URLQueryItem(name: "store_id", value: "\(user?.user.store?[0].id)")
//        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"

        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(userAuthKey, forHTTPHeaderField: "Authorization")
        
        //
        let parameters = ["store_id": "\(user?.user.store?[0].id)",
        ]
        
        guard let mediaImage = Media(withImage: (shopImages?[0]), forKey: "picture") else { return }
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
        
    }
    */
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
    func createShop(){
     

        /*
        let shop = JSONShop(id: 01, ownerID: -1, name: "First Shop", longitude: -69.969330, latitude: 18.488029, zipCode: "10602", description: "Test passed", createdAt: nil, updatedAt: nil, ratings: 05, ownerType: nil, timeTable: "", placeID: nil, style: "beauty_salon", address: "Los Proceres #3")
        
        guard let url = URL(string: "http://54.244.57.51/stores") else {return}
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        
        if let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken"){
            
            request.addValue(userAuthKey, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
        } 
        let body = [    "name": "First Shop",
                        "longitude": "-69.969330",
                        "latitude": "18.488029",
                        "zip_code": "10602",
                        "description": "Test passed",
                        "time_table": "",
                        "style": "beauty_salon"
                    ]
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {return}
        
        request.httpBody = httpBody
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
                 print("!!!!!!!!!!responseeeeeeIS EVERYTHING FINE OUT THERE?")
            }
            if let data = data{
                print(data)
                 print("!!!!!!!!!!DATATATAA IS EVERYTHING FINE OUT THERE?")
                do{
                    // check this deserlization, date objects are causing errors (createdAt and updatedAt)
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                    let newShop = try decoder.decode(JSONShop.self, from: data)
                    print("HEEEEY SHOP \(newShop.name)!!!!!")
                }catch let jsonErr{
                    print("KKKKKKKKKK", jsonErr)
                }
            }
            
        }.resume()
        print("!!!!!!!!!!IS EVERYTHING FINE OUT THERE?")
         */
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

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}




