//
//  Hall.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Hall : Place {
    var order: Int;
    
    init(name: String, order: Int) {
        self.order = order;
        super.init(name: name);
    }
}
