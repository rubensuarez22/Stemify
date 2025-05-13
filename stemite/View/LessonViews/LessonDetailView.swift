//
//  LessonDetailView.swift
//  stemite
//
//  Created by iOS Lab on 13/05/25.
//

import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header with animated character
                ZStack {
                    // Background gradient
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    lesson.isCompleted ? Color.green : Color.blue,
                                    lesson.isCompleted ? Color.green.opacity(0.7) : Color.blue.opacity(0.7)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 200)
                    
                    // Character
                    VStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 120, height: 120)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                                    .frame(width: 120, height: 120)
                            )
                        
                        Text(lesson.title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    Text("Choose an exercise")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Exercise options
                    ForEach(1...4, id: \.self) { index in
                        ExerciseRow(title: "Exercise \(index)", description: "Practice \(lesson.title.lowercased()) with interactive lessons")
                    }
                    
                    Spacer()
                    
                    // Start button
                    Button(action: {
                        // Start lesson
                    }) {
                        Text("Start Lesson")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color.blue.opacity(0.5), radius: 5, x: 0, y: 3)
                            )
                    }
                }
                .padding()
            }
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
            })
        }
    }
}


