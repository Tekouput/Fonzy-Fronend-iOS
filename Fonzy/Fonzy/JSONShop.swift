//
//  JSONShop.swift
//  Fonzy
//
//  Created by fitmap on 2/14/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import Foundation

struct Shops: Codable {
    let stores: [Store]
    let independents: [HairdresserJSON]
    let googleMaps: [GoogleMap]
    
    enum CodingKeys: String, CodingKey {
        case stores = "stores"
        case independents = "independents"
        case googleMaps = "google_maps"
    }
}

struct GoogleMap: Codable, Equatable {

    let geometry: Geometry
    let icon: String
    let id: String
    let name: String
    let openingHours: OpeningHours?
    let photos: [Photo]?
    let placeID: String
    let rating: Double?
    let reference: String
    let scope: String
    let types: [String]
    let vicinity: String
    
    enum CodingKeys: String, CodingKey {
        case geometry = "geometry"
        case icon = "icon"
        case id = "id"
        case name = "name"
        case openingHours = "opening_hours"
        case photos = "photos"
        case placeID = "place_id"
        case rating = "rating"
        case reference = "reference"
        case scope = "scope"
        case types = "types"
        case vicinity = "vicinity"
    }
    
    // Equatable conformance
    static func ==(lhs: GoogleMap, rhs: GoogleMap) -> Bool {
        return
            lhs.id == rhs.id
    }
    
}

struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case viewport = "viewport"
    }
}

struct Location: Codable {
    let lat: Double
    let lng: Double
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
}

struct Viewport: Codable {
    let northeast: Location
    let southwest: Location
    
    enum CodingKeys: String, CodingKey {
        case northeast = "northeast"
        case southwest = "southwest"
    }
}

struct OpeningHours: Codable {
    let openNow: Bool
    let weekdayText: [JSONAny]
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case weekdayText = "weekday_text"
    }
}

struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width = "width"
    }
}

struct TimeTable: Codable {
    let monday: [Day]?
    let tuesday: [Day]?
    let wednesday: [Day]?
    let thrusday: [Day]?
    let friday: [Day]?
    let saturday: [Day]?
    let sunday: [Day]?

}

struct Day: Codable {
    let end: Int
    let start: Int
    
    enum CodingKeys: String, CodingKey {
        case end = "end"
        case start = "start"
    }
}

struct Store: Codable {
    let id: Int
    let ownerID: Int
    let name: String
    let longitude: Double
    let latitude: Double
    let zipCode: String?
    let description: String?
    let createdAt: String
    let updatedAt: String
    let ratings: String?
    let ownerType: String?
    let placeID: String?
    let timeTable: TimeTable?
    let address: Address?
    let style: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownerID = "owner_id"
        case name = "name"
        case longitude = "longitude"
        case latitude = "latitude"
        case zipCode = "zip_code"
        case description = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ratings = "ratings"
        case ownerType = "owner_type"
        case timeTable = "time_table"
        case placeID = "place_id"
        case address
        case style = "style"
    }
}

struct shopAllInfo: Codable {
    let basicInfo: shopInfo
    let hairdressers: [hairdresserBasicInfo]
    let services: [JSONService]
    let photos: [Images]?
    let owner: UserAuth
    
    enum CodingKeys:  String, CodingKey {
        case basicInfo = "basic_info"
        case hairdressers
        case services
        case photos
        case owner
    }
}

struct shopInfo: Codable {
    
    let id: Int
    let title: String
    let zipCode: String?
    let description: String?
    let ratings: String?
    let profilePicture: Image?
    let address: Address?
    
    enum CodingKeys:  String, CodingKey {
        case id
        case title
        case zipCode = "zip_code"
        case description
        case ratings
        case profilePicture = "profile_picture"
        case address
    }
}



    /*
    SHOP INFO + IMAGES
    */

struct ShopInfo: Codable {
    let basicInfo: Store
    let hairdressers: [Independent]
    let services: [JSONService]
    let photos: [Photo]
    let owner: JSONUser2
    
    enum CodingKeys: String, CodingKey {
        case basicInfo = "basic_info"
        case hairdressers, services, photos, owner
    }
}

struct ShopImages: Codable {
    let main: Image?
    let images: [Image]
}

struct Image: Codable {
    let id: Int
    let big, medium, thumb: String?
}

