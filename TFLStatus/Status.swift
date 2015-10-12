//
//  Status.swift
//  TFLStatus
//
//  Created by Javi Manzano on 06/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import Foundation
import UIKit

class Status: NSObject {
    
    var stationName: String
    var arrivals: [Arrival]
    
    init(stationName: String, arrivals: [Arrival]) {
        self.stationName = stationName
        self.arrivals = arrivals
    }
    
    func getStationName() -> String {
        return self.stationName.stringByReplacingOccurrencesOfString(" Underground Station", withString: "")
    }
    
    func getArrivals() -> [Arrival] {
        return self.arrivals.sort({$0.timeToStation < $1.timeToStation})
    }
    
}