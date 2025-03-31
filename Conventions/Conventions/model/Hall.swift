//
//  Place.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Hall {
    var name: String
    var order: Int
    static private var nextAvailableOrder: Int = 0
    
    convenience init(name: String) {
        self.init(name: name, order: Hall.nextAvailableOrder)
        Hall.nextAvailableOrder+=1
    }
    
    init(name: String, order: Int) {
        self.name = name
        self.order = order
    }
}
