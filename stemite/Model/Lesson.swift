//
//  Lesson.swift
//  stemite
//
//  Created by iOS Lab on 13/05/25.

struct Lesson: Identifiable {
let id: Int
let title: String
let isCompleted: Bool
let icon: String
let type: LessonType

enum LessonType {
    case standard
    case checkpoint
    case locked
}
}



