//
//  Address.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/13/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import Foundation

struct Address: Codable {
    let city: String
    let state: String
    let address: [AddressElement]
    let country: String
    let zipCode: String?
    
    enum CodingKeys: String, CodingKey {
        case city
        case state
        case address
        case country
        case zipCode = "zip_code"
    }
    
}

struct AddressElement: Codable {
    let types: [String]?
    let longName, shortName: String?

    enum CodingKeys: String, CodingKey {
        case types
        case longName = "long_name"
        case shortName = "short_name"
    }
}


