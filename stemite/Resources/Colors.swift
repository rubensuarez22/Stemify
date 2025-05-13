//
//  Colors.swift
//  stemite
//
//  Created by iOS Lab on 13/05/25.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    public static let primaryOrange = Color(hex: "#ED9E50")
    public static let cream = Color(hex: "#FDF5EC")
    public static let primaryTextColor = Color(hex: "222222")
    public static let azuli = Color(hex: "4f9fed")
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        

        self.init(red: red, green: green, blue: blue)
    }
}



