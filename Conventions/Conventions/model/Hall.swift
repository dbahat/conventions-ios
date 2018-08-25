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
    
    convenience init(name: String) {
        self.init(name: name, order: 999)
    }
    
    init(name: String, order: Int) {
        self.name = name
        self.order = order
    }
}
