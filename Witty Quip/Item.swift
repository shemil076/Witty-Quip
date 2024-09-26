//
//  Item.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
