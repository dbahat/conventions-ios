//
//  EventType.swift
//  Conventions
//
//  Created by David Bahat on 2/1/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation
import UIKit

class EventType {
    var backgroundColor: UIColor?
    var description: String
    var presentation: Presentation
    
    init(backgroundColor: UIColor?, description: String, presentation: Presentation) {
        self.backgroundColor = backgroundColor
        self.description = description
        self.presentation = presentation
    }
    
    class Presentation {
        var mode: PredentationMode
        var location: PredentationLocation
        
        init(mode: PredentationMode, location: PredentationLocation) {
            self.mode = mode
            self.location = location
        }
        
        // To seperate projected hybrid events from events that were designed for virtual audience
        func designedAsVirtual() -> Bool {
            return mode == .Virtual || (mode == .Hybrid && location == .Virtual)
        }
    }
    
    enum PredentationMode: String {
        case Physical, Virtual, Hybrid
    }
    enum PredentationLocation: String {
        case Indoors, Virtual
    }
}
