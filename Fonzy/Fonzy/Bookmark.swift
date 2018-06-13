//
//  Bookmark.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/8/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import Foundation


class Bookmark {
    
    var shopId: Int
    var shopIcon: UIImage
    var shopName: String
    var shopRating: Double
    var shopAddress: String
    var shopLongitude: Double?
    var shopLatitude: Double?
    
    init(shopId: Int, shopIcon: UIImage, shopName: String, shopRating: Double, shopAddress: String, shopLongitude: Double?, shopLatitude: Double?){
        
        self.shopId = shopId
        self.shopIcon = shopIcon
        self.shopName = shopName
        self.shopRating = shopRating
        self.shopAddress = shopAddress
        self.shopLongitude = shopLongitude
        self.shopLatitude = shopLatitude
    
    }
}

struct JSONBookmark: Codable {
    let id: Int
    let name: String?
    let type: String?
    let profilePicture: Image?
    let address: String?
    let rating: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case profilePicture = "profile_picture"
        case address
        case rating
    }
}
