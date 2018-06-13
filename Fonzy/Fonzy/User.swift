//
//  User.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 11/6/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import Foundation

enum Role {
    case customer
    case hairdresser
    case shopOwner
    case multipleShopOwner
}

enum Sex {
    case male
    case female
    case other
}

class User {
    
    var id: Int = 0
    var firstName: String = ""
    var lastName: String? = ""
    var birthday: Date?
    var sex: Int? = 0
    var zipcode: String? = ""
    var profilePic: UIImage?
    var email: String?
    var password: String? = ""
    var phoneNumber: Double? = 0
    var stripeID: Double?
    var isShopOwner = 0

    init(withId id: Int, firstName: String, lastName: String, birthday: Date, sex: Int, zipCode: String, profilePic: UIImage?, email: String, password: String, phoneNumber: Double, stripeId: Double, isShopOwner: Int ) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.sex = sex
        self.zipcode = zipCode
        self.profilePic = profilePic
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.stripeID = stripeId
        self.isShopOwner = isShopOwner
        
    }
    
    init(firstName: String, lastName: String, sex: Int, zipCode: String, email: String, password: String){
        
        self.firstName = firstName
        self.lastName = lastName
        self.sex = sex
        self.zipcode = zipCode
        self.email = email
        self.password = password
        
    }
    
    init(withId id: Int, profilePic: UIImage, firstName: String, lastName: String, phoneNumber: Double, email: String){
        
        self.id = id
        self.profilePic = profilePic
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
    }
    
    /*let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let someDateTime = formatter.date(from: "2016/10/08 22:31")*/
    
}

// hairdresser_information = Independent, hairdresser_user = UserAuth, dresser_info = userSearch
// Struct UserSearch, specialized in receiving the users from the query methods given user name
struct UserSearch: Codable {
    let id: Int
    let firstName, lastName, sex: String?
    let profilePicture: Image?
    let address, rating: String?
    
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


//
struct MyClient: Codable {
    let id: Int
    let note: String?
    let user: UserSearch

    
    enum CodingKeys: String, CodingKey {
        case id
        case note
        case user
    }
}


// From sign up, etc

struct JSONUser: Codable {
    let firstName, lastName: String?
    let birthDate: String?
    let sex: String?
    let zip, phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case birthDate = "birth_date"
        case sex, zip
        case phoneNumber = "phone_number"
    }
}


struct JSONUser2: Codable {
    let firstName, lastName, birthDay, sex: String?
    let zipCode, phoneNumber: String?
    let id: Int
    let passwordDigest: String
    let profilePic: URL?
    let email: String
    let stripeID: String?
    let idHairdresser: String?
    let isShopOwner: String?
    let createdAt, updatedAt: String
    let uuid, provider, lastLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case birthDay = "birth_day"
        case sex
        case zipCode = "zip_code"
        case phoneNumber = "phone_number"
        case id
        case passwordDigest = "password_digest"
        case profilePic = "profile_pic"
        case email
        case stripeID = "stripe_id"
        case idHairdresser = "id_hairdresser"
        case isShopOwner = "is_shop_owner"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case uuid, provider
        case lastLocation = "last_location"
    }
}

struct Authenticate: Codable {
    let authToken: String
    let user: UserAuth
    let newUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case user
        case newUser = "new_user"
    }
}

// hairdresser_information = Independent, hairdresser_user = UserAuth, dresser_info =
struct UserAuth: Codable {
    let id: Int?
    let firstName, lastName, sex: String?
    let birthday: String?//Date? when this field is marked as date on our API
    let profilePicture: Image? // O String?
    let address: Address?
    let phoneNumber, email: String?
    let stores: [Store]?
    let hairdresserInformation: Independent?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case sex
        case birthday = "birth_day"
        case profilePicture = "profile_picture"
        case address
        case phoneNumber = "phone_number"
        case email, stores
        case hairdresserInformation = "hairdresser_information"
    }
}
