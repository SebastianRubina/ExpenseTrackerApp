//
//  Category.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Category: Identifiable, Hashable {
    var id: String
    var name: String
    var color: ColorRGB
    var icon: String
    
    @Relationship(deleteRule: .cascade, inverse: \Entry.category)
    var entries: [Entry]
    
    init(name: String = "", color: ColorRGB = ColorRGB(), icon: String = "x.circle") {
        self.id = UUID().uuidString
        self.name = name
        self.color = color
        self.icon = icon
        self.entries = []
    }
}

struct ColorRGB: Codable {
    var red: Double
    var green: Double
    var blue: Double
    
    init(red: Double = 1.0, green: Double = 1.0, blue: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    func toColor() -> Color {
        return Color(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}
