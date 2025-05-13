//
//  HomeView.swift
//  stemite
//
//  Created by iOS Lab on 13/05/25.
//

import SwiftUI

struct HomeView: View {
    // Sample lesson data
    let lessons: [Lesson] = [
        Lesson(id: 1, title: "Building Patterns", isCompleted: true, icon: "checkmark", type: .standard),
        Lesson(id: 2, title: "Practice Building Patterns", isCompleted: false, icon: "number", type: .standard),
        Lesson(id: 3, title: "Pattern Rules", isCompleted: false, icon: "square.stack.3d.up", type: .standard),
        Lesson(id: 4, title: "Practice Pattern", isCompleted: false, icon: "number", type: .locked)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Learning Path")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Progress indicator
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("1/4")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Level header
                HStack {
                    Text("LEVEL")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.blue)
                    
                    ZStack {
                        Image(systemName: "hexagon.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                        
                        Text("1")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Learning path with isometric blocks
                ZStack {
                    // Background dotted pattern
                    IsometricPatternBackground()
                    
                    // Path lines
                    IsometricPathLines(lessons: lessons)
                    
                    // Lesson blocks positioned at each point
                    ForEach(lessons) { lesson in
                        IsometricLessonBlock(lesson: lesson)
                            .position(positionForLesson(id: lesson.id))
                    }
                }
                .frame(height: 750)
                .padding(.horizontal)
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 1.0).ignoresSafeArea())
    }
    
    // Calculate positions for each lesson node based on ID
    private func positionForLesson(id: Int) -> CGPoint {
        switch id {
        case 1:
            return CGPoint(x: 160, y: 200)
        case 2:
            return CGPoint(x: 240, y: 380)
        case 3:
            return CGPoint(x: 180, y: 560)
        case 4:
            return CGPoint(x: 160, y: 740)
        default:
            return CGPoint(x: 180, y: 300)
        }
    }
}


// Background with isometric dots pattern
struct IsometricPatternBackground: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            Path { path in
                // Create a grid of dots
                let spacing = 30.0
                for x in stride(from: 0, to: width, by: spacing) {
                    for y in stride(from: 0, to: height, by: spacing) {
                        let offsetX = y.truncatingRemainder(dividingBy: (2 * spacing)) == 0 ? 0 : spacing/2
                        path.addEllipse(in: CGRect(x: x + offsetX, y: y, width: 2, height: 2))
                    }
                }
            }
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        }
    }
}

// Isometric path lines connecting the lesson blocks
struct IsometricPathLines: View {
    let lessons: [Lesson]
    
    var body: some View {
        Path { path in
            // Starting point
            path.move(to: CGPoint(x: 120, y: 140))
            
            // First segment - down and right
            path.addLine(to: CGPoint(x: 160, y: 180))
            
            // Continue to lesson 1
            path.addLine(to: CGPoint(x: 160, y: 200))
            
            // From lesson 1 to next segment
            path.move(to: CGPoint(x: 160, y: 220))
            path.addLine(to: CGPoint(x: 160, y: 280))
            
            // Curve to next lesson
            path.addQuadCurve(
                to: CGPoint(x: 240, y: 360),
                control: CGPoint(x: 200, y: 320)
            )
            
            // To lesson 2
            path.addLine(to: CGPoint(x: 240, y: 380))
            
            // From lesson 2 to lesson 3
            path.move(to: CGPoint(x: 240, y: 400))
            path.addQuadCurve(
                to: CGPoint(x: 180, y: 540),
                control: CGPoint(x: 210, y: 470)
            )
            
            // To lesson 3
            path.addLine(to: CGPoint(x: 180, y: 560))
            
            // From lesson 3 to lesson 4
            path.move(to: CGPoint(x: 180, y: 580))
            path.addQuadCurve(
                to: CGPoint(x: 160, y: 720),
                control: CGPoint(x: 170, y: 650)
            )
            
            // To lesson 4
            path.addLine(to: CGPoint(x: 160, y: 740))
        }
        .stroke(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue.opacity(0.5)]),
                startPoint: .top,
                endPoint: .bottom
            ),
            style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
        )
        
        // Special marker for active part of the path
        Path { path in
            // Green marker for the active lesson
            let activeLessonIndex = lessons.firstIndex(where: { !$0.isCompleted }) ?? 0
            
            if activeLessonIndex > 0 && activeLessonIndex < lessons.count {
                path.addEllipse(in: CGRect(x: 225, y: 365, width: 30, height: 30))
            }
        }
        .fill(Color.green)
    }
}

// Isometric 3D block for each lesson node
struct IsometricLessonBlock: View {
    let lesson: Lesson
    @State private var isPressed: Bool = false
    @State private var showLessonView: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            // 3D Isometric Block
            ZStack {
                // Bottom layer (shadow)
                IsometricBlock(size: 50, depth: 14, color: lesson.isCompleted ? Color.blue : (lesson.type == .locked ? Color.gray : Color.blue))
                    .offset(y: isPressed ? 2 : 0)
                
                // Icon in the center
                ZStack {
                    Rectangle()
                        .fill(lesson.isCompleted ? Color.blue : (lesson.type == .locked ? Color.gray.opacity(0.8) : Color.blue.opacity(0.8)))
                        .frame(width: 44, height: 44)
                    
                    if lesson.type == .locked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: lesson.icon)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .offset(y: isPressed ? 2 : 0)
            }
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 5)
            
            // Lesson title
            Text(lesson.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(width: 120)
        }
        .opacity(lesson.type == .locked ? 0.7 : 1.0)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        // Navigation and press effects only if not locked
        .onTapGesture {
            if lesson.type != .locked {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    isPressed = true
                }
                
                // Reset the pressed state after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                    showLessonView = true
                }
            }
        }
        .sheet(isPresented: $showLessonView) {
            if lesson.type != .locked {
                LessonDetailView(lesson: lesson)
            }
        }
    }
}

// Isometric 3D block
struct IsometricBlock: View {
    let size: CGFloat
    let depth: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            // Top face
            Rectangle()
                .fill(color)
                .frame(width: size, height: size)
            
            // Right side face
            Path { path in
                path.move(to: CGPoint(x: size/2, y: -size/2))
                path.addLine(to: CGPoint(x: size/2 + depth, y: -size/2 + depth/2))
                path.addLine(to: CGPoint(x: size/2 + depth, y: size/2 + depth/2))
                path.addLine(to: CGPoint(x: size/2, y: size/2))
                path.closeSubpath()
            }
            .fill(color.opacity(0.8))
            
            // Left side face
            Path { path in
                path.move(to: CGPoint(x: -size/2, y: -size/2))
                path.addLine(to: CGPoint(x: -size/2 + depth, y: -size/2 + depth/2))
                path.addLine(to: CGPoint(x: -size/2 + depth, y: size/2 + depth/2))
                path.addLine(to: CGPoint(x: -size/2, y: size/2))
                path.closeSubpath()
            }
            .fill(color.opacity(0.6))
        }
    }
}

// Exercise row component
struct ExerciseRow: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            // Exercise icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "book.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
            }
            
            // Exercise details
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}


#Preview {
    HomeView()
}
    
    
