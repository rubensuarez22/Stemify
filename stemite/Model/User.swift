//
//  User.swift
//  stemite
//
//  Created by iOS Lab on 13/05/25.
//

import Foundation
import SwiftUI

struct User {
    var id: UUID
    var gender: String
    var avatar: Image?
    var skills: [String: Int]? = [
        "Computer Science": 95,
        "Mechanical Engineering": 92,
        "Electrical Engineering": 88
    ]
}

