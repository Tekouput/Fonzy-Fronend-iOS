//
//  UserMethods.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 5/23/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class UserMethods {
    
    
    class func getCurrentUserRole() -> Role {
        
//        1. Get user info
//        2. Check Stores, if empty
//        3. Check hairdresser info, if empty
//        4. Is customer
        
        var role = Role.customer
        
        self.getCurrentUserInfo { (user) in
            
            let isStoreEmpty = user?.stores?.isEmpty ?? true
            var isHairdresserEmpty = true
            if user?.hairdresserInformation != nil { isHairdresserEmpty = false }

            if !isStoreEmpty {
                // Is an ShopOwner
                
                let storeCount = user?.stores?.count ?? 0
                
                if storeCount > 0 {
                    role = Role.multipleShopOwner
                } else {
                    role = Role.shopOwner
                }

            } else if !isHairdresserEmpty {
                // Is a hairdresser
                role = Role.hairdresser
            } else {
                // Is a customer
                role = Role.customer
            }
            
        }
        
        return role
    }
    
    class func getCurrentUserInfo(completion: ((UserAuth?) -> ())?) {
        
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
                    completion?(user)
                    
                } catch let err {
                    print("Error while parsing user from AuthKey: ", err)
                }
                
                }.resume()
            
        }
    }

}
