//
//  Hairdresser.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/8/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import Foundation


class Hairdresser {
    
    var Id: Int
    var name: String
    var profilePicture: UIImage
    
    
    init(Id: Int, name: String, profilePicture: UIImage){
        
        self.Id = Id
        self.name = name
        self.profilePicture = profilePicture
        
    }
    
}





// To parse the JSON, add this file to your project and do:
//


typealias HairdresserShop = [HairdresserShopElement]

struct HairdresserShopElement: Codable {
    let request: Request
    let hairDresserUser: HairDresserUser
    
    enum CodingKeys: String, CodingKey {
        case request
        case hairDresserUser = "hair_dresser_user"
    }
}

struct HairDresserUser: Codable {
    let firstName, lastName, sex: String?
    let profilePicture: Image?
    let phoneNumber: String?
    let email: String
    let store: [Store]?
    let hairdresserInformation: HairdresserInformation
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case sex
        case profilePicture = "profile_picture"
        case phoneNumber = "phone_number"
        case email, store
        case hairdresserInformation = "hairdresser_information"
    }
}

struct HairdresserInformation: Codable {
    let id: Int
    let isIndependent: Bool?
    let longitude, latitude: String
    let description: String?
    let onlinePayment: Bool?
    let rating: String?
    let state: Bool?
    let userID: Int
    let createdAt, updatedAt: String
    let timeTable: TimeTable?
    let address: HairdresserInformationAddress?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isIndependent = "is_independent"
        case longitude, latitude, description
        case onlinePayment = "online_payment"
        case rating, state
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case timeTable = "time_table"
        case address
    }
}

struct HairdresserInformationAddress: Codable {
    let city, state: String?
    let address: [AddressElement]?
    let country: String?
    let zipcode: String?
}

struct Request: Codable {
    let id, storeID, hairDresserID: Int?
    let confirmerID, confirmerType: String?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case storeID = "store_id"
        case hairDresserID = "hair_dresser_id"
        case confirmerID = "confirmer_id"
        case confirmerType = "confirmer_type"
        case status
    }
}


// Ultimate object to parse hairdresser info
// hairdresser_information = Independent, hairdresser_user = UserAuth, dresser_info = userSearch
struct HairdresserJSON: Codable {
    let info: HairdresserInfo
    let user: UserAuth
//    let hairdresser: Independent
    
    enum CodingKeys: String, CodingKey {
        case info = "dresser_info"
        case user = "hairdresser_user"
//        case hairdresser = "hairdresser_information"
    }
}

struct HairdresserInfo: Codable {
    let id: Int
    let firstName, lastName, sex: String?
    let profilePicture: Image?
    let address: Address?
    let rating: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case sex
        case profilePicture = "profile_picture"
        case address
        case rating
    }
}


// hairdresser_information = Independent, hairdresser_user = UserAuth, dresser_info = userSearch
struct Independent: Codable {
    let id: Int
    let isIndependent: Bool?
    let longitude: String
    let latitude: String
    let description: String
    let onlinePayment: Bool
    let rating: Double?
    let state: Bool
    let userID: Int
    let createdAt: String
    let updatedAt: String
    let timeTable: TimeTable?
    let address: Address?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case isIndependent = "is_independent"
        case longitude = "longitude"
        case latitude = "latitude"
        case description = "description"
        case onlinePayment = "online_payment"
        case rating = "rating"
        case state = "state"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case timeTable = "time_table"
        case address = "address"
    }
}

struct hairdresserBasicInfo: Codable {
    
    let id: Int
    let firstName, lastName: String?
    let birthdate, sex, zipCode: String?
    let profilePicture: Image?
    let phoneNumber, email, stripeId: String?
    let hairdresserId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case birthdate = "age"
        case sex
        case zipCode = "zip_code"
        case profilePicture = "profile_pic"
        case phoneNumber = "phone_number"
        case email
        case stripeId = "stripe_id"
        case hairdresserId = "id_hairdresser"
    }
    
}
