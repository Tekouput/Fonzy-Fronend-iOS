//
//  Deal.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 12/7/17.
//  Copyright © 2017 Biocore. All rights reserved.
//

import Foundation

class Deal {
    
    var id: Int
    var name: String
    var description: String
    var initialDate: Date
    var endDate: Date
    var saving: Double
    
    init(id: Int, name: String, description: String, initialDate: Date, endDate: Date, saving: Double){
        
        self.id = id
        self.name = name
        self.description = description
        self.initialDate = initialDate
        self.endDate = endDate
        self.saving = saving
        
    }
    
}
