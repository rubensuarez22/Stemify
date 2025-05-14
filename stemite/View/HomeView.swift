import SwiftUI
import SceneKit


// MARK: - Alternative SceneKit Implementation
struct Milestone3DView: View {
    let milestone: Milestone
    @State private var isPressed = false
    @Binding var selectedMilestone: Milestone?
    
    private let nodeSize: CGFloat = 70
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                    selectedMilestone = milestone
                }
            }
        }) {
            ZStack {
                // Shadow
                Circle()
                    .fill(Color(UIColor.systemGray.withAlphaComponent(0.3)))
                    .frame(width: nodeSize, height: nodeSize)
                    .offset(y: 5)
                    .blur(radius: 5)
                
                // Main circle in 3D style with gradients and effects
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(milestone.isCompleted ?
                                      UIColor.systemBlue : UIColor.systemOrange),
                                Color(milestone.isCompleted ?
                                      UIColor.systemBlue.withAlphaComponent(0.7) :
                                      UIColor.systemOrange.withAlphaComponent(0.7))
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color(UIColor.white.withAlphaComponent(0.6)),
                                        Color(UIColor.white.withAlphaComponent(0.0))
                                    ]),
                                    center: .topLeading,
                                    startRadius: 0,
                                    endRadius: nodeSize/2
                                )
                            )
                            .mask(
                                Circle()
                                    .padding(4)
                            )
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                Color(UIColor.white.withAlphaComponent(0.6)),
                                lineWidth: 1.5
                            )
                    )
                    .frame(width: nodeSize, height: nodeSize)
                
                // Icon
                Image(systemName: milestone.isCompleted ? "checkmark" : "flag.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: Color(UIColor.black.withAlphaComponent(0.3)), radius: 1, x: 1, y: 1)
            }
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .shadow(
                color: Color(UIColor.black.withAlphaComponent(0.5)),
                radius: 10,
                x: 0,
                y: 5
            )
            .overlay(
                Text(milestone.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(UIColor.darkText))
                    .multilineTextAlignment(.center)
                    .frame(width: 100)
                    .padding(.top, 8)
                    .offset(y: nodeSize / 2 + 10)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - ZigZag Path
struct ZigZagPath: View {
    let count: Int
    let width: CGFloat
    let height: CGFloat
    let zigzagWidth: CGFloat
    
    var body: some View {
        Path { path in
            let verticalSpacing = height / CGFloat(count + 1)
            let centerX = width / 2
            
            // Start at the top center
            path.move(to: CGPoint(x: centerX, y: verticalSpacing/2))
            
            // Create zigzag pattern
            for i in 0..<count {
                let y = verticalSpacing * (CGFloat(i) + 1)
                let x = centerX + (i % 2 == 0 ? zigzagWidth : -zigzagWidth)
                
                // Create curved lines
                if i > 0 {
                    let prevY = verticalSpacing * CGFloat(i)
                    let prevX = centerX + ((i-1) % 2 == 0 ? zigzagWidth : -zigzagWidth)
                    
                    // Control points for smooth curve
                    let control1 = CGPoint(x: prevX, y: prevY + verticalSpacing/3)
                    let control2 = CGPoint(x: x, y: y - verticalSpacing/3)
                    
                    path.addCurve(to: CGPoint(x: x, y: y),
                                  control1: control1,
                                  control2: control2)
                } else {
                    // First segment - straight line or gentle curve
                    let control1 = CGPoint(x: centerX, y: verticalSpacing/2 + verticalSpacing/3)
                    let control2 = CGPoint(x: x, y: y - verticalSpacing/3)
                    
                    path.addCurve(to: CGPoint(x: x, y: y),
                                 control1: control1,
                                 control2: control2)
                }
            }
        }
        .stroke(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.azuli,
                    Color.primaryOrange
                ]),
                startPoint: .top,
                endPoint: .bottom
            ),
            style: StrokeStyle(lineWidth:
                               6, lineCap: .round, lineJoin: .round)
        )
    }
}

// MARK: - Challenge Detail View
struct ChallengeDetailView: View {
    let milestone: Milestone
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 60))
                .foregroundColor(milestone.isCompleted ? Color.azuli : Color.primaryOrange)
                .padding()
            
            Text(milestone.title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color(UIColor.darkText))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(milestone.description)
                .font(.system(size: 18))
                .foregroundColor(Color(UIColor.darkText.withAlphaComponent(0.8)))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            if !milestone.isCompleted {
                Button(action: {
                    // Action for completing challenge
                }) {
                    Text("Start Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220)
                        .background(Color(UIColor.systemOrange))
                        .cornerRadius(25)
                        .shadow(color: Color(UIColor.black.withAlphaComponent(0.2)), radius: 5, x: 0, y: 2)
                }
                .padding(.top, 20)
            } else {
                Text("Challenge Completed")
                    .font(.headline)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cream)
    }
}

// MARK: - Main View with LandingPage Header
struct MilestonePathView: View {
    @State private var milestones: [Milestone] = [
        Milestone(id: 1, title: "First Challenge", isCompleted: true, description: "This is the first challenge. You've already completed it."),
        Milestone(id: 2, title: "Pattern Recognition", isCompleted: false, description: "Learn to identify patterns in data structures."),
        Milestone(id: 3, title: "Problem Solving", isCompleted: false, description: "Apply your knowledge to solve complex problems."),
        Milestone(id: 4, title: "Final Challenge", isCompleted: false, description: "Put everything together in this final challenge.")
    ]
    
    @State private var selectedMilestone: Milestone? = nil
    
    // User stats from LandingPage
    @State private var userLevel: Int = 5
    @State private var currentXP: Double = 75
    @State private var nextLevelXP: Double = 100
    @State private var totalStars: Int = 125
    
    // Colors from LandingPage
    let primaryTextColor = Color(UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0)) // #2C3E50
    let secondaryTextColor = Color(UIColor(red: 0.5, green: 0.55, blue: 0.55, alpha: 1.0)) // #7F8C8D
    let levelHexagonColor = Color(UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0)) // #F39C12
    let progressBarColor = Color(Color.azuli) // #33658A
    let starColor = Color(UIColor(red: 0.95, green: 0.77, blue: 0.06, alpha: 1.0)) // #F1C40F
    
    // Constants for zigzag layout
    private let horizontalZigZagOffset: CGFloat = 80
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.cream.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // ----- HEADER FROM LANDING PAGE -----
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("NIVEL")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(secondaryTextColor)
                                .kerning(0.8)
                            ZStack {
                                Image(systemName: "hexagon.fill")
                                    .resizable().scaledToFit().frame(width: 28, height: 28)
                                    .foregroundColor(levelHexagonColor)
                                Text("\(userLevel)")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        GeometryReader { geo in
                            Capsule()
                                .fill(progressBarColor.opacity(0.2)).frame(height: 6)
                                .overlay(alignment: .leading) {
                                    Capsule().fill(progressBarColor)
                                        .frame(width: geo.size.width * min(1, max(0, (currentXP / nextLevelXP))), height: 6)
                                }
                        }
                        .frame(height: 6)
                        .padding(.leading, 8)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 16)).foregroundColor(starColor)
                            Text("\(totalStars)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(primaryTextColor)
                            Text("+")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(secondaryTextColor)
                                .offset(y: -3)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, (UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.top ?? 0) > 20 ? 10 : 20)
                    .padding(.bottom, 15)
                    .background(Color.cream.ignoresSafeArea())
                    // ----- END HEADER -----
                    
                    // Original MilestonePathView Content inside ScrollView
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Path Header
                            HStack {
                                Text("CHATGPT RESPONDE ASÍ A TUS PREGUNTAS 🤖")
                                    .font(.system(size: 28, weight: .heavy))
                                    .foregroundColor(primaryTextColor)
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal, 20)
                            
                            // Path and milestones
                            GeometryReader { geometry in
                                ZStack {
                                    // Background pattern (optional)
                                    ForEach(0..<20, id: \.self) { row in
                                        ForEach(0..<10, id: \.self) { col in
                                            Circle()
                                                .fill(Color(UIColor.systemOrange.withAlphaComponent(0.05)))
                                                .frame(width: 4, height: 4)
                                                .offset(
                                                    x: CGFloat(col) * 40 + (row % 2 == 0 ? 20 : 0),
                                                    y: CGFloat(row) * 40
                                                )
                                        }
                                    }
                                    
                                    // ZigZag path
                                    ZigZagPath(
                                        count: milestones.count,
                                        width: geometry.size.width,
                                        height: geometry.size.height,
                                        zigzagWidth: horizontalZigZagOffset
                                    )
                                    
                                    // Milestone nodes positioned in ZigZag pattern
                                    ForEach(0..<milestones.count, id: \.self) { index in
                                        Milestone3DView(
                                            milestone: milestones[index],
                                            selectedMilestone: $selectedMilestone
                                        )
                                        .position(
                                            x: geometry.size.width / 2 + (index % 2 == 0 ? horizontalZigZagOffset : -horizontalZigZagOffset),
                                            y: geometry.size.height / CGFloat(milestones.count + 1) * CGFloat(index + 1)
                                        )
                                    }
                                }
                            }
                            .frame(height: 600) // Set a fixed height for the GeometryReader
                            .padding(.horizontal, 20)
                            
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedMilestone) { milestone in
                ChallengeDetailView(milestone: milestone)
            }
        }
    }
}

// MARK: - Preview
struct MilestonePathView_Previews: PreviewProvider {
    static var previews: some View {
        MilestonePathView()
    }
}
