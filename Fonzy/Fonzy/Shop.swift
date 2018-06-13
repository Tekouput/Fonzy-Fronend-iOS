//
//  Shop.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 10/27/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import Foundation


class Shop {
    
    var id: String
    var name: String
    var status: String
    var longitude: Double
    var latitude: Double
    var zipCode: String?
    var description: String?
    var rating: Int?
    var services: [Service]?
    var pictures: [UIImage]?
    
    init(withId id: String, name: String, status: String, longitude: Double, latitude: Double, zipCode: String, description: String, rating: Int, pictures: [UIImage]) {
        
        self.id = id
        self.name = name
        self.status = status
        self.longitude = longitude
        self.latitude = latitude
        self.zipCode = zipCode
        self.description = description
        self.rating = rating
        
        self.pictures = pictures
    }
    
    
}







// To parse the JSON, add this file to your project and do:
//
//   let shopMapInfo = try ShopMapInfo(json)


struct ShopMapInfo: Codable {
    let addressComponents: [AddressComponent]
    let adrAddress, formattedAddress, formattedPhoneNumber: String?
    let geometry: GeometryInfo?
    let icon, id, internationalPhoneNumber, name: String?
    let openingHours: OpeningHoursInfo?
    let photos: [PhotoInfo]?
    let placeID, reference, scope: String
    let types: [String]
    let url: String
    let utcOffset: Int?
    let vicinity: String
    
    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case adrAddress = "adr_address"
        case formattedAddress = "formatted_address"
        case formattedPhoneNumber = "formatted_phone_number"
        case geometry, icon, id
        case internationalPhoneNumber = "international_phone_number"
        case name
        case openingHours = "opening_hours"
        case photos
        case placeID = "place_id"
        case reference, scope, types, url
        case utcOffset = "utc_offset"
        case vicinity
    }
}

struct AddressComponent: Codable {
    let longName, shortName: String?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

struct GeometryInfo: Codable {
    let location: LocationInfo?
    let viewport: ViewportInfo?
}

struct LocationInfo: Codable {
    let lat, lng: Double?
}

struct ViewportInfo: Codable {
    let northeast, southwest: Location?
}

struct OpeningHoursInfo: Codable {
    let openNow: Bool?
    let periods: [Period]?
    let weekdayText: [String]?
    
    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case periods
        case weekdayText = "weekday_text"
    }
}

struct Period: Codable {
    let close, periodOpen: Close?
    
    enum CodingKeys: String, CodingKey {
        case close
        case periodOpen = "open"
    }
}

struct Close: Codable {
    let day: Int?
    let time: String?
}

enum Time: String, Codable {
    case the0200 = "0200"
    case the1030 = "1030"
    case the1830 = "1830"
}

struct PhotoInfo: Codable {
    let height: Int?
    let htmlAttributions: [String]?
    let photoReference: String?
    let width: Int?
    
    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}

// MARK: Convenience initializers

extension ShopMapInfo {
    init(data: Data) throws {
        self = try JSONDecoder().decode(ShopMapInfo.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension AddressComponent {
    init(data: Data) throws {
        self = try JSONDecoder().decode(AddressComponent.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension GeometryInfo {
    init(data: Data) throws {
        self = try JSONDecoder().decode(GeometryInfo.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Location {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Location.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Viewport {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Viewport.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension OpeningHoursInfo {
    init(data: Data) throws {
        self = try JSONDecoder().decode(OpeningHoursInfo.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Period {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Period.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Close {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Close.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension PhotoInfo {
    init(data: Data) throws {
        self = try JSONDecoder().decode(PhotoInfo.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}








