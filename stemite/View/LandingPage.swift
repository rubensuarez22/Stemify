import SwiftUI

// ASUMIMOS que MissionTeaser, sampleMissionTeasers, y Color(hex:)
// están definidos en tu archivo de Modelos (ej. Models/MissionData.swift)
// y que MissionTeaser incluye:
// let challengesCount: Int
// let xpRewardTotal: Int

struct LandingPage: View {
    @State var missionTeasers: [MissionTeaser] = sampleMissionTeasers // Asegúrate que esta variable global esté definida y accesible
    
    @State private var userLevel: Int = 5
    @State private var currentXP: Double = 75
    @State private var nextLevelXP: Double = 100
    @State private var totalStars: Int = 125

    // Colores
    let backgroundColor = Color.white
    let primaryTextColor = Color(hex: "#2C3E50") // Un gris oscuro azulado para texto principal
    let secondaryTextColor = Color(hex: "#7F8C8D") // Gris para texto secundario
    let levelHexagonColor = Color(hex: "#F39C12") // Naranja para el hexágono del nivel
    let progressBarColor = Color(hex: "#33658A") // Verde para la barra de progreso
    let starColor = Color(hex: "#F1C40F") // Amarillo/Naranja para la estrella

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16), // Espacio horizontal ENTRE las tarjetas de una misma fila
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.cream.ignoresSafeArea()

                VStack(spacing: 0) { // Sin espaciado aquí para que el header se pegue al ScrollView
                    
                    // ----- INICIO: HEADER FIJO -----
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("NIVEL")
                                .font(.system(size: 9, weight: .bold)) // TÚ ACCIÓN: FUENTE
                                .foregroundColor(secondaryTextColor)
                                .kerning(0.8)
                            ZStack {
                                Image(systemName: "hexagon.fill")
                                    .resizable().scaledToFit().frame(width: 28, height: 28)
                                    .foregroundColor(levelHexagonColor)
                                Text("\(userLevel)")
                                    .font(.system(size: 14, weight: .bold)) // TÚ ACCIÓN: FUENTE
                                    .foregroundColor(.white)
                            }
                        }
                        
                        GeometryReader { geo in
                            Capsule()
                                .fill(progressBarColor.opacity(0.2)).frame(height: 6)
                                .overlay(alignment: .leading) {
                                    Capsule().fill(progressBarColor)
                                        .frame(width: geo.size.width * min(1, max(0, (currentXP / nextLevelXP))), height: 6) // Asegura que el ancho esté entre 0 y el total
                                }
                        }
                        .frame(height: 6)
                        .padding(.leading, 8)
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 16)).foregroundColor(starColor)
                            Text("\(totalStars)")
                                .font(.system(size: 14, weight: .bold)) // TÚ ACCIÓN: FUENTE
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
                    // ----- FIN: HEADER FIJO -----

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) { // Espaciado para el título y el grid
                            
                            Text("ELIGE TU MISIÓN,\nCRACK 🚀")
                                .font(.system(size: 28, weight: .heavy)) // TÚ ACCIÓN: FUENTE
                                .foregroundColor(primaryTextColor)
                                .lineSpacing(4)
                                .padding(.horizontal, 20)
                                // El padding top lo da el spacing del VStack o el .padding(.bottom) del header

                            LazyVGrid(columns: columns, spacing: 16) { // `spacing` aquí es el espacio VERTICAL entre filas
                                ForEach(missionTeasers) { teaser in
                                    MissionCardViewNew(missionTeaser: teaser)
                                        .onTapGesture {
                                            print("Misión seleccionada: \(teaser.title)")
                                            // Aquí tu lógica de navegación:
                                            // Por ejemplo, si tienes un @State para mostrar un modal o navegar:
                                            // selectedMission = teaser
                                            // showMissionIntro = true
                                        }
                                }
                            }
                            .padding(.horizontal, 15) // Padding horizontal para el grid
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        // .accentColor(accentOrange) // Si quieres que elementos de NavigationView usen este color
    }
}

// Solución alternativa con GeometryReader para mayor control
struct MissionCardViewNew: View {
    let missionTeaser: MissionTeaser
    let cardTextColor = Color.white
    let cardInfoColor = Color.white.opacity(0.9)
    let iconInfoColor = Color.yellow
    
    // Computar dinámicamente el tamaño de la fuente basado en la longitud del título
    private var dynamicTitleFontSize: CGFloat {
        let titleLength = missionTeaser.title.count
        if titleLength > 35 {
            return 12 // Títulos muy largos
        } else if titleLength > 25 {
            return 13 // Títulos largos
        } else {
            return 14 // Títulos normales o cortos
        }
    }

    var body: some View {
        // Usar GeometryReader para tener control preciso del tamaño
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                // Contenedor principal con bordes redondeados
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.clear)
                    .frame(width: geometry.size.width, height: 170)
                
                // Imagen con overlay
                ZStack {
                    // La imagen base
                    Image(missionTeaser.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 2.7)
                        .frame(width: geometry.size.width, height: 170)
                    
                    // Gradiente inferior
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.7), Color.black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    // Gradiente superior
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.4), .clear]),
                        startPoint: .top,
                        endPoint: .init(x: 0.5, y: 0.3)
                    )
                }
                .frame(width: geometry.size.width, height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Contenido de texto e información
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
                    
                    if let subtitle = missionTeaser.subtitle {
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
                            Text("\(missionTeaser.challengesCount) Retos")
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
                
                // Tag (Nuevo/Popular)
                if let tag = missionTeaser.tag {
                    Text(tag.rawValue)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(tag == .nuevo ? Color(hex: "#33658A") : Color(hex: "#8AC926"))
                        .clipShape(Capsule())
                        .padding([.top, .leading], 8)
                }
            }
            .frame(width: geometry.size.width, height: 170)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)
        }
        .frame(height: 170) // Altura fija para el GeometryReader
    }
}

// --- Preview ---
struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}

