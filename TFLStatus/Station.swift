//
//  Station.swift
//  TFLStatus
//
//  Created by Javi Manzano on 08/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import Foundation

class Station {
    
    var id: String
    var name: String
    var lat: Double
    var lon: Double
    
    init(id: String, name: String, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lon = lon
    }
    
    func getDisplayName() -> String {
        let stationName = self.name.stringByReplacingOccurrencesOfString(" Underground Station", withString: "")
        return "\(stationName): \(self.lat), \(self.lon)"
    }
    
}