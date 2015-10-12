//
//  StatusCell.swift
//  TFLStatus
//
//  Created by Javi Manzano on 12/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import Foundation
import UIKit

class StatusCell: UITableViewCell {
    
    @IBOutlet weak var status: UILabel!
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
}