//
//  Universities.swift
//  stemite
//
//  Created by iOS Lab on 13/05/25.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - Models
struct University: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let address: String
    let careers: [String]
    let description: String
    let website: URL?
    let imageURL: String?
}
