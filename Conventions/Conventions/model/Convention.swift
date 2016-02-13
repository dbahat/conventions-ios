//
//  Convention.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

class Convention {
    static let instance = Convention();
    
    var halls: Array<Hall>?;
    var events: Array<ConventionEvent>!;
    let date = Date.from(year: 2016, month: 3, day: 23);
}

