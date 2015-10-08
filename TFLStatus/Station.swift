//
//  Station.swift
//  TFLStatus
//
//  Created by Javi Manzano on 08/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import MapKit
import Foundation

class Station: NSObject, MKAnnotation {
    
    var id: String
    var name: String
    let coordinate: CLLocationCoordinate2D
    
    init(id: String, name: String, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        super.init()
    }
    
    var title: String? {
        return self.name
    }
    
    var subtitle: String? {
        return self.id
    }
    
}