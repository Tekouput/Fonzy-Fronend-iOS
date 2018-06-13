//
//  MapViewController.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 9/15/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol shopLoadDelegate {
    func pass(shops: Shops)
}



class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var shops: Shops?
    
    var mapShops = [String: GoogleMap]()
    var fonzyShops = [Int: Store]()
    var hairdressers = [Int: Independent]()
    
    var delegate: shopLoadDelegate?
    var shopCoordinates = [CLLocationCoordinate2D]()
    let locationManager = CLLocationManager()
    var radius = 2500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        GMSServices.provideAPIKey("AIzaSyBlB8bfbvb6HQmxbgqFMD-eihHvxR49wgI")
        
        // Ask for user location
        getUserLocation()
        
        startReceivingLocationChanges()
        
        loadMapsShop()
        
        
        
        if let shops = shops {
            delegate?.pass(shops:  shops)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        //First: take shop id
        
        if let shopId = marker.title {
            print("\n\n\n\n\n \(shopId) \n\n\n\n\n")
            //Send the shopId to the methods in charge to fetch all shop info
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let id = marker.title {
            if Int(id) != nil{
                
                // Its from us, Fonzy
                
                //Second: instantiate the next view controller (shop profile)
                
                let nextViewController = storyboard.instantiateViewController(withIdentifier: "shopProfileNavC") as! UINavigationController
                
                let shopProfile = nextViewController.topViewController as! ShopProfileViewController
                shopProfile.shop = fonzyShops[Int(id)!]
                
                //Third: find the top most view controller and present the shop profile there
                
                // Note: this code is from StackOverFlow
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.present(nextViewController, animated: true, completion: nil)
                }
                
                
            }else{
                // Its from GMaps
                
                let nextViewController = storyboard.instantiateViewController(withIdentifier: "googleMapShopProfileNavC") as! UINavigationController
                let shopProfile = nextViewController.topViewController as! GoogleMapShopProfileViewController
                shopProfile.shopMapImage = takeMapImage()
                shopProfile.shop = mapShops[marker.title!]//shops?.googleMaps[4]
                
                // Note: this code is from StackOverFlow
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.present(nextViewController, animated: true, completion: nil)
                }
            }
        }
        return true
    }
    
    
    func takeMapImage() -> UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: - User location
    
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
    
    
    
    func loadMapsShop() {
        
        let shopType = Search.type.rawValue //"hair_care" // or beauty salon //"beauty_salon"
        var shopOpenDate = "" // It belongs to Date type utf iso8680 enconding
        var shopOpenTime = "" // It's Int
        var shopOpenDay = "" // It's Int
        var shopAvgPrice = "" // Int
        var shopCities = "" //
        
        if let userLocation = locationManager.location {
            
            //            http://54.244.57.51/find/places?latitude=18.4707538&longitude=-69.9205690&distance_break=2000&style=beauty_salon&open_at=&time=&day=2&price=40&city=seo
            
            var link = Config.fonzyUrl + "find/places"
            var url = URLComponents(string: link)!
            
            url.queryItems = [
                URLQueryItem(name: "latitude", value: "\(userLocation.coordinate.latitude)"),
                URLQueryItem(name: "longitude", value:  "\(userLocation.coordinate.longitude)"),
                URLQueryItem(name: "distance_break", value: "\(radius)"),
                URLQueryItem(name: "style", value: shopType),
                URLQueryItem(name: "open_at", value: "\(shopOpenDate)"),
                URLQueryItem(name: "time", value: "\(shopOpenTime)"),
                URLQueryItem(name: "day", value: "\(shopOpenDay)"),
                URLQueryItem(name: "price", value: "\(shopAvgPrice)"),
                URLQueryItem(name: "city", value: "\(shopCities)"),
            ]
            
            var request = URLRequest(url: url.url!)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) {[weak self] (data, response, err) in
                
                guard let data = data else {return}
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //                    print(json)
                    self?.shops = try JSONDecoder().decode(Shops.self, from: data)
                    guard let shops = self?.shops else {return}
                    //                    print(self?.shops)
                    self?.draw(shops: shops, userLocation: userLocation.coordinate)
                    test.Shops = shops
                    self?.delegate?.pass(shops: shops)
                } catch let err {
                    print("Error while parsing shops object", err)
                }
                
                }.resume()
        }
    }
    
    
    func draw(shops: Shops, userLocation: CLLocationCoordinate2D) {
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 14)
        
        DispatchQueue.main.async {
            let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
            self.view = mapView
            DispatchQueue.global(qos: .userInitiated).async {
                for shop in shops.googleMaps {
                    let loc = CLLocationCoordinate2D(latitude: shop.geometry.location.lat, longitude: shop.geometry.location.lng)
                    let marker = GMSMarker(position: loc)
                    marker.map = mapView
                    marker.icon = UIImage(named: "fonzyPin")
                    marker.title = shop.id;
                    
                    self.mapShops[shop.id] = shop
                }
                for shop in shops.stores {
                    let loc = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude) // TODO: CRITICAL FIX: idk why it parses longitude as latitude and viceversa
                    let marker = GMSMarker(position: loc)
                    marker.map = mapView
                    marker.icon = UIImage(named: "fonzyPin")
                    marker.title = "\(shop.id)";
                    
                    self.fonzyShops[shop.id] = shop
                }
                for independent in shops.independents {
                    guard let latitudeString = independent.user.hairdresserInformation?.latitude else {return}
                    guard let longitudeString = independent.user.hairdresserInformation?.latitude else {return}
                    
                    guard let latitude = Double(latitudeString) else {return}
                    guard let longitude = Double(longitudeString) else {return}
                    let loc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let marker = GMSMarker(position: loc)
                    marker.map = mapView
                    marker.icon = UIImage(named: "fonzyPin")
                    marker.title = "\(independent.user.hairdresserInformation?.id)";
                    
                    guard let id = independent.user.hairdresserInformation?.id else {return}
                    guard let hairdresserInformation = independent.user.hairdresserInformation else {return}
                    
                    self.hairdressers[id] = hairdresserInformation
                }
            }
            mapView.delegate = self
        }
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


