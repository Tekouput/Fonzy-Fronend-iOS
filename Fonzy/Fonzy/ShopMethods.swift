//
//  ShopMethods.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/25/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class ShopMethods {
    
    
    /*
     * Search for shops on Google Maps
     */
    
    static func loadMapsShop(latitude: Double, longitude: Double, radius: Double, shopType: String, shopOpenDate: String, shopOpenTime: String, shopOpenDay: String, shopAvgPrice: String, shopCities: String, completion: ((Shops) -> ())?) {
        
        
        //            /find/places?latitude=18.4707538&longitude=-69.9205690&distance_break=2000&style=beauty_salon&open_at=&time=&day=2&price=40&city=seo
        
        let link = Config.fonzyUrl + "find/places"
        var url = URLComponents(string: link)!
        
        url.queryItems = [
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value:  "\(longitude)"),
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
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            guard let data = data else {return}
            do{
                // let json = try JSONSerialization.jsonObject(with: data, options: [])
                // print(json)
                let shops = try JSONDecoder().decode(Shops.self, from: data)
                //                    print(self?.shops)
                //                test.Shops = shops
                completion?(shops)
            } catch let err {
                print("Error while parsing shops object", err)
            }
            
            }.resume()
        
    }
    
    
    
    
    /*
     Get all hairdressers from shop
     */
    static func getAllHairdressersFromShop(withId id: Int, completion: (([HairdresserShopElement]) -> ())? ) {
        
        let link = Config.fonzyUrl + "stores/hairdressers"
        var url = URLComponents(string: link)!
        url.queryItems =
            [
                URLQueryItem(name: "store_id", value: "\(id)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            print("Shop team response: ", response)
            print("shop team Data: ", data)
            guard let data = data else {return}
            
            do {
                let hairdressers = try JSONDecoder().decode([HairdresserShopElement].self, from: data)
                print("Shop has \(hairdressers.count) hairdressers")
                completion?(hairdressers)
            } catch let err {
                print("Error while parsing shop hairdressers: ", err)
            }
            
            }.resume()
    }
    
    
    /*
     Get all shop pictures
     */
    
    static func getAllPicturesFromShop(withId id: Int, completion: ((ShopImages) -> ())?) {
        
        let link = Config.fonzyUrl + "stores/pictures"
        var url = URLComponents(string: link)!
        url.queryItems =
            [
                URLQueryItem(name: "store_id", value: "\(id)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            print("Shop team response: ", response)
            print("shop team Data: ", data)
            guard let data = data else {return}
            
            do {
                let images = try JSONDecoder().decode(ShopImages.self, from: data)
                print("Images parsed correctly: ", images.images.count)
                
                completion?(images)
            } catch let err {
                print("Error while parsing shop images: ", err)
            }
            
            }.resume()
    }
    
    
    class func getFirstShopFromToken(completion: ((Store?) -> ())?) {
        
        var user: UserAuth?
        
        if let userToken = KeychainWrapper.standard.string(forKey: "authToken") {
            
            let link = Config.fonzyUrl + "users"
            let url = URLComponents(string: link)!
            
            var request = URLRequest(url: url.url!)
            request.httpMethod = "GET"
            request.addValue(userToken, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) {(data, response, err) in
                
//                print("heeey response: ", response)
//                print("Hey data: ",data)
                guard let data = data else {return}
                
                do {
                    user = try JSONDecoder().decode(UserAuth.self, from: data)
                    print("User successfully parsed: ", user?.firstName)
                    
                    // Return shop
                    completion?(user?.stores?.first)
                    
                } catch let err {
                    print("Error while parsing user from AuthKey: ", err)
                }
                
                }.resume()
            
        }
    }
    
    
}
