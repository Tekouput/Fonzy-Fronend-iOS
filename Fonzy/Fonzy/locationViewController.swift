//
//  locationViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 8/21/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import SwiftKeychainWrapper

class locationViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {

    var userRole = Role.shopOwner
    var user: UserAuth?

    
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet var zipCodeTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!

    @IBOutlet weak var locMapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    var shopLocation: CLLocationCoordinate2D?
    
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyBlB8bfbvb6HQmxbgqFMD-eihHvxR49wgI")

        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationViewController.dismissKeyboard)))
        
//        zipCodeTextField.delegate = self
        phoneNumberTextField.delegate = self
       
        
        // Ask for user location
        getUserLocation()
        
        startReceivingLocationChanges()
        
        if let userLocation = locationManager.location {
            
            let camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 14)
            
            locMapView.camera = camera
            locMapView.delegate = self
            
            
            //MARKER
            
            let initialMarker = GMSMarker()
            //initialMarker.icon = UIImage(named: "")
            initialMarker.isDraggable = true
            initialMarker.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            initialMarker.map = locMapView
            
            /*
            let camera = GMSCameraPosition.camera(withLatitude: 18.487924, longitude: -69.962265, zoom: 14)
            let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
            
            self.view = mapView
            */
            
            // Set default shopLocation, in case user do not move the pin, the location will be the current user location
            shopLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
        }
        
        locationManager.stopUpdatingLocation()
        
        
        activityIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func dismissKeyboard() {
//        zipCodeTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
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
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("LATITUDE: \(marker.position.latitude)")
        print("LONGITUDE: \(marker.position.longitude)")
        shopLocation = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        /*
        let cameraZoom = mapView.camera.zoom
        let latitude = (marker.position.latitude - (0.005 * Double(cameraZoom)))
        let longitude = (marker.position.longitude - (0.005 * Double(cameraZoom)))
            
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: cameraZoom)
        */
    }

    func getUserLocation(){
        locationManager.delegate = self as? CLLocationManagerDelegate
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
        //Disable location features and let user know we can't do it because their preferences
            break
        case .authorizedWhenInUse, .authorizedAlways:
            //Do my location stuff
            break
        }
    }

    
    
    func startReceivingLocationChanges() {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
    
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled(){
            // Location services is not available.
            return
        }
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways{
            
            // Configure and start the service.
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 50.0  // In meters.
            locationManager.delegate = self //as? CLLocationManagerDelegate
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        switch textField.tag {
//        case 0...2:
//            print("ok")
//        default:
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)

        //}

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    

    @IBAction func unwindToLocation(segue: UIStoryboardSegue){
        //
    }
    
    
    @IBAction func ContinueButtonTapped(_ sender: Any) {
        
        if userRole == .hairdresser {
            activityIndicator("Registering")
            
            getUserInfoFromAuthKey {
                self.updateHairdresserInfo()
            }
            
            
        }
        
    }
    
    func updateHairdresserInfo() {
        
        let link = Config.fonzyUrl + "users/hairdressers/bind"
        guard let url = URL(string: link) else {return}

        guard let longitude = shopLocation?.longitude else {return}
        guard let latitude = shopLocation?.latitude else {return}
        
        let parameters =
        [
            "is_independent": true,
            "longitude": "\(longitude)",
            "latitude": "\(latitude)",
            "description": "",
            "online_payment": true,
            "state": true
        ] as [String : Any]
        
        print(parameters)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        request.httpBody = body
        
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        if let userAuthKey = KeychainWrapper.standard.string(forKey: "authToken") {
            request.addValue(userAuthKey, forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) {[weak self]  (data, response, error)  in
            
            print("Patch hairdresser response: ", response)
            
            guard let data = data else {return}
            do{
                
                DispatchQueue.main.async { [weak self] in
                    self?.stopActivityIndicator()
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let shopOwnerVC = storyboard.instantiateViewController(withIdentifier: "createShopViewController")
                    self?.present(shopOwnerVC, animated: true, completion: nil)
                }
                let kk = try JSONDecoder().decode(JSONHairdresser.self, from: data)
                print("HEY KK FROM THE HAIRDRESSER")
                print(kk)
                
                
            }catch let err {
                print("Error while inserting hairdresser :", err)
            }
            
            
            
            }.resume()
        
    }
    
    func getUserInfoFromAuthKey(completion: (() -> ())?) {
        
        if let userToken = KeychainWrapper.standard.string(forKey: "authToken") {
            
            let link = Config.fonzyUrl + "users"
            let url = URLComponents(string: link)!
            
            var request = URLRequest(url: url.url!)
            request.httpMethod = "GET"
            request.addValue(userToken, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
                
                print("heeey response: ", response)
                print("Hey data: ",data)
                guard let data = data else {return}
    
                do {
                    self?.user = try JSONDecoder().decode(UserAuth.self, from: data)
                    print("User successfully parsed: ", self?.user?.firstName)
                    completion?()
                    
                } catch let err {
                    print("Error while parsing user from AuthKey: ", err)
                }
                
            }.resume()
            
        }
        
        
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if userRole == .hairdresser {
            return false
        }
        
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
    
        
        // Pass the selected object to the new view controller.
        if let addShopVC = segue.destination as? addShopViewController{
            addShopVC.userRole = .shopOwner
            addShopVC.shopLocation = shopLocation
            if let phoneText = phoneNumberTextField.text {
                addShopVC.shopPhoneNumber = Double(phoneText)
            }
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
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        effectView.removeFromSuperview()
    }
    
 

}
