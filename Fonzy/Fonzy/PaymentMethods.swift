//
//  PaymentMethods.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/24/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import Foundation
import Stripe

class PaymentMethods {
    
    
    static func payInvoice(withId id: Int, cardToken token: STPToken, authorization authKey: String, completion: (() -> ())?) {
        
        
        let link = Config.fonzyUrl + "invoice/pay"
        var url = URLComponents(string: link)!
        url.queryItems =
            [
                URLQueryItem(name: "invoice_id", value: "\(id)"),
                URLQueryItem(name: "stripe_token", value: token.tokenId)
        ]
        
        var request = URLRequest(url: url.url!)
        request.addValue(authKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "PATCH"
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            print("Pay Invoice response: ", response)
            print("Pay Invoice Data: ", data)
            guard let data = data else {return}
            
            do {

                completion?()
            } catch let err {
                print("Error while parsing Pay Invoice: ", err)
            }
            
        }.resume()
        
    }
    
    
    
    
    func submitTokenToBackend(token: STPToken, completion: (() -> ())?) {
        
        
        
    }
    
}
