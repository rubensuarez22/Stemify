import SwiftUI

struct LandingPage: View {
    @State var missionTeasers: [MissionTeaser] = sampleMissionTeasers
    
    @State private var userLevel: Int = 5
    @State private var currentXP: Double = 75
    @State private var nextLevelXP: Double = 100
    @State private var totalStars: Int = 125

    // State for navigation
    @State private var navigateToMilestonePath: Bool = false
    @State private var selectedMissionTitle: String = ""

    // Colores
    let backgroundColor = Color.white
    let primaryTextColor = Color(hex: "#2C3E50") // Un gris oscuro azulado para texto principal
    let secondaryTextColor = Color(hex: "#7F8C8D") // Gris para texto secundario
    let levelHexagonColor = Color(hex: "#F39C12") // Naranja para el hexágono del nivel
    let progressBarColor = Color(Color.azuli) // Azul oscuro para la barra de progreso
    let starColor = Color(hex: "#F1C40F") // Amarillo/Naranja para la estrella

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.cream.ignoresSafeArea()

                // NavigationLink to MilestonePathView
                // It's "hidden" because navigation is triggered programmatically by $navigateToMilestonePath
                NavigationLink(
                    destination: MilestonePathView(),
                    isActive: $navigateToMilestonePath
                ) {
                    EmptyView()
                }

                VStack(spacing: 0) {
                    // ----- INICIO: HEADER FIJO -----
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("LVL") // slang
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
                    .background(Color.cream.ignoresSafeArea()) // Mantener el fondo del header
                    // ----- FIN: HEADER FIJO -----

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            Text("PICK YOUR QUEST,\nLEGEND 🚀") // slang
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundColor(primaryTextColor)
                                .lineSpacing(4)
                                .padding(.horizontal, 20)

                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(missionTeasers) { teaser in
                                    MissionCardViewNew(missionTeaser: teaser)
                                        .onTapGesture {
                                            print("Misión seleccionada: \(teaser.title)")
                                            self.selectedMissionTitle = teaser.title // Store the title
                                            self.navigateToMilestonePath = true // Trigger navigation
                                        }
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        // .accentColor(accentOrange) // Uncomment if you have accentOrange defined and want to use it
    }
}

struct MissionCardViewNew: View {
    let missionTeaser: MissionTeaser
    let cardTextColor = Color.white
    let cardInfoColor = Color.white.opacity(0.9)
    let iconInfoColor = Color.yellow // Was Color(hex: "#F1C40F"), yellow is more direct
    
    private var dynamicTitleFontSize: CGFloat {
        let titleLength = missionTeaser.title.count
        if titleLength > 35 { return 12 }
        else if titleLength > 25 { return 13 }
        else { return 14 }
    }

    private var tagText: String {
        guard let tag = missionTeaser.tag else { return "" }
        // Assuming MissionTag is an enum like: enum MissionTag { case nuevo, popular }
        switch tag {
            case .nuevo: return "FRESH DROP ✨" // slang
            case .popular: return "TRENDING 🔥" // slang
            default: return tag.rawValue.uppercased() // Fallback if other tags exist
        }
    }

    private var tagBackgroundColor: Color {
        guard let tag = missionTeaser.tag else { return .clear }
        switch tag {
        case .nuevo: return Color(Color.azuli) // Blue
            case .popular: return Color(hex: "#8AC926") // Green
            default: return Color.gray
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.clear)
                    .frame(width: geometry.size.width, height: 170)
            
                ZStack {
                    Image(missionTeaser.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 2.7)
                        .frame(width: geometry.size.width, height: 170)
                
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.7), Color.black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                        
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.4), .clear]),
                        startPoint: .top,
                        endPoint: .init(x: 0.5, y: 0.3)
                    )
                }
                .frame(width: geometry.size.width, height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(alignment: .leading, spacing: 5) {
                    Spacer()
                    
                    Text(missionTeaser.title.uppercased())
                        .font(.system(size: dynamicTitleFontSize, weight: .heavy))
                        .foregroundColor(cardTextColor)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .lineSpacing(0)
                        .fixedSize(horizontal: false, vertical: true)
                        .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 1)
                    
                    if let subtitle = missionTeaser.subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(cardTextColor.opacity(0.85))
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                            .padding(.bottom, 6)
                    }
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 3) {
                            Image(systemName: "list.bullet.rectangle.portrait.fill")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(iconInfoColor)
                            Text("\(missionTeaser.challengesCount) Quests") // slang
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(cardInfoColor)
                        }
                        
                        HStack(spacing: 3) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(iconInfoColor)
                            Text("\(missionTeaser.xpRewardTotal) XP")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(cardInfoColor)
                        }
                        Spacer()
                    }
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                }
                .padding(10)
                .frame(width: geometry.size.width, height: 170, alignment: .bottomLeading)
                
                if missionTeaser.tag != nil {
                    Text(tagText) // slang
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(tagBackgroundColor)
                        .clipShape(Capsule())
                        .padding([.top, .leading], 8)
                }
            }
            .frame(width: geometry.size.width, height: 170)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)
        }
        .frame(height: 170)
    }
}

// --- Preview ---
struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        // Mock MissionTeaser and MissionTag for preview if needed
        // enum MissionTag: String { case nuevo, popular }
        // struct MissionTeaser: Identifiable { /* ... */ var tag: MissionTag? }
        // let sampleMissionTeasers = [ /* ... */ ]
        LandingPage()
    }
}
