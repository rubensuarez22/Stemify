//
//  Milestones.swift
//  stemite
//
//  Created by iOS Lab on 13/05/25.
//

// MARK: - Models
struct Milestone: Identifiable {
    let id: Int
    let title: String
    var isCompleted: Bool
    let description: String
}
