//
//  Service.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 10/29/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import Foundation

class Service {
    
    var id: Int = 0
    var icon: UIImage?
    var name: String
    var price: Double
    var estimatedTime: Double
    var categoryName: String
    var description: String?
    var statusName: String?
    
    init(id: Int, icon: UIImage?, name: String, price: Double, estimatedTime: Double, categoryName: String, description: String, statusName: String){
        
        self.id = id
        self.icon = icon
        self.name = name
        self.price = price
        self.estimatedTime = estimatedTime
        self.categoryName = categoryName
        self.description = description
        self.statusName = statusName
        
    }
}


struct JSONService: Codable {
    
    let id: Int
    let name, description, price, duration: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price, duration
    }
}

struct ServiceDescription: Codable {
    let id: Int?
    let name, description, price, duration: String
    let watcher: Watcher?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price, duration
        case watcher
    }
}

/*
 "service": {
 "name": "Recorte para chicas",
 "description": "Recortar ninias sde todas las edades",
 "price": "90.0",
 "duration": "3600",
 "watcher": {
 "type": "NilClass",
 "info": ""
 }
 */



