//
//  FavoriteStation.swift
//  TFLStatus
//
//  Created by Javi Manzano on 10/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import Foundation
import CoreData

class FavoriteStation: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
}
