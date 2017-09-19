//
//  ConventionHomeContentViewProtocol.swift
//  Conventions
//
//  Created by David Bahat on 18/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

protocol ConventionHomeContentViewProtocol : class {
    func navigateToEventsClicked()
    func navigateToUpdatesClicked()
    func navigateToEventClicked(event: ConventionEvent)
}
