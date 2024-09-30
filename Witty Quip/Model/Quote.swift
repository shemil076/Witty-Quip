//
//  Quote.swift
//  Witty Quip
//
//  Created by Pramuditha Karunarathna on 2024-09-25.
//

import Foundation
import SwiftData

@Model
class Quote{
    @Attribute(.unique) var id: UUID
    @Attribute var text: String
    @Attribute var isFavourite: Bool
    @Attribute var updatedDate: Date
    
    
    init(text: String, isFavourite: Bool = false ){
        self.id = UUID()
        self.text = text
        self.isFavourite = isFavourite
        self.updatedDate = Date()
    }
}
