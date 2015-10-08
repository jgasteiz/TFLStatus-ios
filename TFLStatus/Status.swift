//
//  Status.swift
//  TFLStatus
//
//  Created by Javi Manzano on 06/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import Foundation

class Status: NSObject {
    
    var stationName: String
    var lineName: String
    var arrivals: [Arrival]
    
    init(stationName: String, lineName: String, arrivals: [Arrival]) {
        self.stationName = stationName
        self.lineName = lineName
        self.arrivals = arrivals
    }
    
    func getSummary() -> String {
        var summary = ""
        
        // Reorder the arrivals by time to station.
        self.arrivals = self.arrivals.sort({$0.timeToStation < $1.timeToStation})
        
        // Render inbound
        for arrival in arrivals {
            if arrival.direction == "inbound" {
                summary = "\(summary)\(arrival.getSummary())\n"
            }
        }
        
        // Separation
        summary = "\(summary)\n=========\n\n"
        
        // Render outbound
        for arrival in arrivals {
            if arrival.direction == "outbound" {
                summary = "\(summary)\(arrival.getSummary())\n"
            }
        }
        
        return summary
    }
    
}