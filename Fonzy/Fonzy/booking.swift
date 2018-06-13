//
//  booking.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/8/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import Foundation
import CoreLocation

class Booking{
    
    var serviceId: Int?
    var serviceName: String?
    var statusId: Int?
    var statusName: String?
    var date: Date?
    var address: String?
    var longitude: Double?
    var latitude: Double?
    var shopId: Int?
    var shopName: String?
    var hairdresserId: Int?
    var hairdresserName: String?
    
    init(serviceName: String, statusName: String, date: Date, address: String, longitude: Double?, latitude: Double?, shopId: Int, shopName: String, hairdresserId: Int, hairdresserName: String){
        
        self.serviceName = serviceName
        self.statusName = statusName
        self.date = date
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
        self.shopId = shopId
        self.shopName = shopName
        self.hairdresserId = hairdresserId
        self.hairdresserName = hairdresserName
    }
    
}


struct JSONBooking: Codable {
    let id: Int
    let state: Bool
    let bookTime, bookNote, bookDate: String?
    let paymentMethod: Int
    let service: ServiceDescription
    let handler: Handler
    let user: UserSearch
    
    enum CodingKeys: String, CodingKey {
        case id, state
        case bookTime = "book_time"
        case bookNote = "book_note"
        case bookDate = "book_date"
        case paymentMethod = "payment_method"
        case service, handler, user
    }
}

struct Handler: Codable {
    let type: String
    let info: UserAuth?
}

struct Watcher: Codable {
    let type: String
    let info: shopInfo?
}



struct BookingRequest: Codable {
    let id: Int
    let status: Int
    let store: Store
    let hairdresser: Independent
    let confirmer: String
    
    enum codingKeys: String, Codable {
        case id
        case status
        case store
        case hairdresser
        case confirmer
    }
}
