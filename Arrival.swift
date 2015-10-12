//
//  Arrival.swift
//  TFLStatus
//
//  Created by Javi Manzano on 08/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import Foundation

class Arrival: NSObject {
    
    var platformName: String?
    var timeToStation: Int?
    var direction: String?
    var currentLocation: String?
    var towards: String?
    
    init(platformName: String?, timeToStation: Int?, direction: String?, currentLocation: String?, towards: String?) {
        self.platformName = platformName
        self.timeToStation = timeToStation
        self.direction = direction
        self.currentLocation = currentLocation
        self.towards = towards
    }
    
    func getSummary() -> String {
        return "\(self.towards!) - \(self.timeToStation! / 60) min"
    }
    
}