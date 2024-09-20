//
//  ColorExtension.swift
//  ExpenseTrackerApp
//
//  Created by Sebastián Rubina on 2024-09-19.
//

import Foundation
import SwiftUI

extension Color {
    // Calculate the relative luminance of the color
    func luminance() -> Double {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0]
        let red = components[0]
        let green = components[1]
        let blue = components[2]

        // Formula for luminance: 0.2126*R + 0.7152*G + 0.0722*B
        return (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
    }

    // Determines if the color is light or dark based on luminance
    func isLight() -> Bool {
        return self.luminance() > 0.5 // Luminance > 0.5 is considered light
    }
    
    func toRGB() -> (red: Double, green: Double, blue: Double)? {
            let uiColor = UIColor(self)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                return (Double(red), Double(green), Double(blue))
            } else {
                return nil
            }
        }
}
