import SwiftUI

// MARK: - Modelos (Definidos aquí para que el archivo sea autocontenido)
// En un proyecto más grande, estos irían en un archivo de Modelos separado.
enum LessonType {
    case standard
    case checkpoint
    case locked
}



// MARK: - Vista Principal HomeView

struct HomeView: View {
    // Sample lesson data
    @State var lessons: [Lesson] = [ // @State si isCompleted puede cambiar
        Lesson(id: 1, title: "Building Patterns", isCompleted: true, icon: "checkmark.seal.fill", type: .standard),
        Lesson(id: 2, title: "Practice Building Patterns", isCompleted: false, icon: "number.circle.fill", type: .standard), // Cambié a ícono más visual
        Lesson(id: 3, title: "Pattern Rules", isCompleted: false, icon: "square.stack.3d.up.fill", type: .standard),
        Lesson(id: 4, title: "Practice Pattern", isCompleted: false, icon: "lock.circle.fill", type: .locked), // Cambié a ícono más visual
        Lesson(id: 5, title: "Advanced Challenge", isCompleted: false, icon: "star.fill", type: .standard),
        Lesson(id: 6, title: "Final Project", isCompleted: false, icon: "flag.checkered.2.crossed", type: .locked)
    ]
    
    // --- Colores y Fuentes (Ejemplos, ¡AJÚSTALOS!) ---
    let headerTextColor = Color.primary // Se adapta a Light/Dark mode
    let levelColor = Color.blue       // TÚ ACCIÓN: Define tu color
    let pathBackgroundColor = Color(red: 0.97, green: 0.97, blue: 0.985) // Un gris/lila muy pálido

    // --- Parámetros para el Layout Isométrico Dinámico ---
    let nodeVisualWidth: CGFloat = 100  // Ancho del VStack del IsometricLessonBlock (incluyendo título)
    let nodeVisualHeight: CGFloat = 80 // Alto APROXIMADO del VStack del IsometricLessonBlock (para centrar)
    
    let verticalSpacingPerNode: CGFloat = 140 // Espacio vertical ENTRE CENTROS de nodos
    let horizontalZigZagMagnitude: CGFloat = 60 // Cuánto se mueve a izq/der en el zigzag
    let pathHorizontalPadding: CGFloat = 20 // Padding a los lados del ZStack del path
    
    
    // Nuevos parámetros para las barras laterales
    let sideBarWidth: CGFloat = 10 // Ancho de cada barra lateral individual
    let sideBarHeight: CGFloat = 40 // Alto de cada barra lateral individual
    let sideBarDepth: CGFloat = 6    // Profundidad isométrica de la barra lateral
    let sideBarSpacing: CGFloat = 6  // Espacio entre barras laterales en un grupo
    let sideBarGroupOffsetX: CGFloat = 120 // Cuánto se separan del centro del path

    
    // Propiedades computadas para el progreso
    var currentOverallProgress: Int {
        lessons.filter { $0.isCompleted }.count
    }
    var totalDisplayableLessons: Int { // Lecciones que se muestran en el progreso (no bloqueadas o un subconjunto)
        // Podrías tener una lógica más compleja aquí si el path tiene "secciones" o niveles
        lessons.count // Por ahora, todas las lecciones
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) { // Espaciado general del VStack
                // Header
                HStack {
                    Text("Learning Path") // TÚ ACCIÓN: FUENTE
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(headerTextColor)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.yellow) // TÚ ACCIÓN: COLOR
                        Text("\(currentOverallProgress)/\(totalDisplayableLessons)") // TÚ ACCIÓN: FUENTE
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(levelColor.opacity(0.1)) // TÚ ACCIÓN: COLOR
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Level header
                HStack {
                    Text("LEVEL") // TÚ ACCIÓN: FUENTE
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(levelColor) // TÚ ACCIÓN: COLOR
                    ZStack {
                        Image(systemName: "hexagon.fill")
                            .resizable().scaledToFit().frame(width: 35, height: 35)
                            .foregroundColor(levelColor) // TÚ ACCIÓN: COLOR
                        Text("1") // TÚ ACCIÓN: FUENTE (Podrías calcular el nivel)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                GeometryReader { geometry in
                    let containerWidth = geometry.size.width
                    let centerX = containerWidth / 2

                    ZStack {
                        IsometricPatternBackground()
                        
                        DynamicIsometricPathLines(
                            lessons: lessons,
                            nodeVisualHeight: nodeVisualHeight,
                            verticalSpacing: verticalSpacingPerNode,
                            horizontalMagnitude: horizontalZigZagMagnitude, // Pasando el parámetro
                            containerWidth: containerWidth // Pasando el ancho del contenedor
                        )

                        ForEach(lessons.indices, id: \.self) { index in
                            let lesson = lessons[index]
                            IsometricLessonBlock(lesson: lesson)
                                .frame(width: nodeVisualWidth)
                                .position(calculateNodePosition(
                                    forIndex: index,
                                    totalLessons: lessons.count,
                                    verticalSpacing: verticalSpacingPerNode,
                                    horizontalMagnitude: horizontalZigZagMagnitude,
                                    containerWidth: containerWidth, // Usamos el ancho del GeometryReader
                                    topPadding: nodeVisualHeight * 0.7 // Ajusta para el primer nodo
                                ))
                        }
                    }
                    // Altura dinámica para el contenedor del path
                    .frame(height: max(400, CGFloat(lessons.count) * verticalSpacingPerNode + nodeVisualHeight))
                }
                // No necesitas el .padding(.horizontal, pathHorizontalPadding) aquí si el GeometryReader ya ocupa el ancho deseado.
                // Si quieres que el path esté más centrado, aplica padding al GeometryReader o ajusta el cálculo de centerX.
                .padding(.horizontal, pathHorizontalPadding) // Mantenemos un padding general para el área del path

            }
            .padding(.bottom, 30)
        }
        .background(pathBackgroundColor.ignoresSafeArea())
    }
    
    // --- Lógica de Posicionamiento Dinámico para los BLOQUES ---
    func calculateNodePosition(forIndex index: Int, totalLessons: Int, verticalSpacing: CGFloat, horizontalMagnitude: CGFloat, containerWidth: CGFloat, topPadding: CGFloat) -> CGPoint {
        let yPos = topPadding + CGFloat(index) * verticalSpacing
        let centerX = containerWidth / 2 // Centro del espacio disponible para el path
        
        var xPos = centerX
        if totalLessons > 1 {
            if index == 0 { // Primer nodo ligeramente a la izquierda si el siguiente va a la derecha
                xPos = centerX + ((1 % 2 == 0) ? -0.25 : 0.25) * horizontalMagnitude * ( (lessons.count > 2) ? 1 : 0) // Centrado si solo hay 2
            } else if index == totalLessons - 1 { // Último nodo
                xPos = centerX + (((totalLessons - 2) % 2 == 0) ? -0.25 : 0.25) * horizontalMagnitude * ( (lessons.count > 2) ? 1 : 0) // Centrado si solo hay 2
            } else { // Nodos intermedios
                let direction: CGFloat = (index % 2 == 0) ? -0.5 : 0.5
                xPos = centerX + direction * horizontalMagnitude
            }
        }
        return CGPoint(x: xPos, y: yPos)
    }
}

// MARK: - Subvistas (Tus structs actuales, algunas modificadas)

struct IsometricPatternBackground: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width; let height = geometry.size.height
            Path { path in
                let spacing = 30.0
                for xCoord in stride(from: 0, to: width, by: spacing) {
                    for yCoord in stride(from: 0, to: height, by: spacing) {
                        let offsetX = yCoord.truncatingRemainder(dividingBy: (2 * spacing)) == 0 ? 0 : spacing/2
                        path.addEllipse(in: CGRect(x: xCoord + offsetX, y: yCoord, width: 2, height: 2))
                    }
                }
            }.stroke(Color.gray.opacity(0.2), lineWidth: 1) // Más sutil
        }
    }
}

struct DynamicIsometricPathLines: View {
    let lessons: [Lesson]
    let nodeVisualHeight: CGFloat
    let verticalSpacing: CGFloat
    let horizontalMagnitude: CGFloat
    let containerWidth: CGFloat // Ancho del GeometryReader que contiene el path
    
    // Lógica de posicionamiento (debe ser idéntica a la de HomeView para los bloques)
    private func calculateNodePosition(forIndex index: Int) -> CGPoint {
        let yPos = nodeVisualHeight / 2 + CGFloat(index) * verticalSpacing // Centro Y del nodo
        let centerX = containerWidth / 2
        
        var xPos = centerX
        if lessons.count > 1 {
            if index == 0 {
                xPos = centerX + ((1 % 2 == 0) ? -0.25 : 0.25) * horizontalMagnitude * ( (lessons.count > 2) ? 1 : 0)
            } else if index == lessons.count - 1 {
                xPos = centerX + (((lessons.count - 2) % 2 == 0) ? -0.25 : 0.25) * horizontalMagnitude * ( (lessons.count > 2) ? 1 : 0)
            } else {
                let direction: CGFloat = (index % 2 == 0) ? -0.5 : 0.5
                xPos = centerX + direction * horizontalMagnitude
            }
        }
        return CGPoint(x: xPos, y: yPos)
    }

    var body: some View {
        Path { path in
            guard lessons.count > 1 else { return }

            for i in 0..<(lessons.count - 1) {
                let startPoint = calculateNodePosition(forIndex: i)
                let endPoint = calculateNodePosition(forIndex: i + 1)
                
                path.move(to: startPoint)
                
                // Lógica de curva suave (ajusta los puntos de control según sea necesario)
                let midX = (startPoint.x + endPoint.x) / 2
                let midY = (startPoint.y + endPoint.y) / 2
                
                // Puntos de control para crear una forma de 'S' suave entre nodos
                let control1X = startPoint.x
                let control1Y = midY
                let control2X = endPoint.x
                let control2Y = midY
                
                if abs(startPoint.x - endPoint.x) < 10 { // Si están casi verticales, línea recta
                    path.addLine(to: endPoint)
                } else {
                    path.addCurve(to: endPoint,
                                  control1: CGPoint(x: control1X, y: control1Y + (startPoint.y < endPoint.y ? 20 : -20)),
                                  control2: CGPoint(x: control2X, y: control2Y - (startPoint.y < endPoint.y ? 20 : -20)))
                }
            }
        }
        .stroke(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue.opacity(0.3)]), // TÚ ACCIÓN: COLOR
                startPoint: .top,
                endPoint: .bottom
            ),
            style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
        )
        // Podrías añadir aquí el marcador de lección activa
        // calculando la posición del primer `lesson` donde `!isCompleted`.
    }
}

struct IsometricLessonBlock: View {
    let lesson: Lesson
    @State private var isPressed: Bool = false
    @State private var showLessonView: Bool = false
    
    var blockColor: Color {
        lesson.isCompleted ? Color.green.opacity(0.7) : (lesson.type == .locked ? Color.gray.opacity(0.5) : Color.blue.opacity(0.7)) // TÚ ACCIÓN: COLORES
    }
    var iconContainerColor: Color { // Para el fondo del ícono si es diferente al bloque
        lesson.isCompleted ? Color.green : (lesson.type == .locked ? Color.gray : Color.blue)
    }

    var body: some View {
        VStack(spacing: 6) { // Menor espaciado
            ZStack {
                IsometricBlock(size: 40, depth: 10, color: blockColor) // Bloque más pequeño
                    .offset(y: isPressed ? 1 : 0)
                
                ZStack { // Contenedor del ícono
                    // Puedes usar un Circle o Rectangle como fondo del ícono si deseas
                    // Circle().fill(iconContainerColor.opacity(0.5)).frame(width: 30, height: 30)
                    
                    if lesson.type == .locked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 13, weight: .bold)) // TÚ ACCIÓN: FUENTE
                            .foregroundColor(.white.opacity(0.8))
                    } else {
                        Image(systemName: lesson.icon)
                            .font(.system(size: 16, weight: .bold)) // TÚ ACCIÓN: FUENTE
                            .foregroundColor(.white)
                    }
                }
                .offset(y: isPressed ? 0.5 : -1.5) // Ajuste fino del ícono
            }
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0.5, y: 1.5) // Sombra más sutil
            
            Text(lesson.title)
                .font(.system(size: 11, weight: .medium)) // TÚ ACCIÓN: FUENTE
                .foregroundColor(Color.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .frame(width: 90, height: 28) // Ajusta para que el texto quepa
                .lineLimit(2)
        }
        .opacity(lesson.type == .locked ? 0.65 : 1.0)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            if lesson.type != .locked {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { isPressed = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { isPressed = false }
                    showLessonView = true
                }
            }
        }
        .sheet(isPresented: $showLessonView) {
            if lesson.type != .locked {
                LessonDetailView(lesson: lesson) // Asume que LessonDetailView está definida
            }
        }
    }
}

struct IsometricBlock: View {
    let size: CGFloat; let depth: CGFloat; let color: Color
    var body: some View {
        ZStack {
            Rectangle().fill(color).frame(width: size, height: size)
            Path { path in path.move(to: CGPoint(x: size/2, y: -size/2)); path.addLine(to: CGPoint(x: size/2 + depth, y: -size/2 + depth/2)); path.addLine(to: CGPoint(x: size/2 + depth, y: size/2 + depth/2)); path.addLine(to: CGPoint(x: size/2, y: size/2)); path.closeSubpath() }.fill(color.opacity(0.85)) // Más opaco para mejor 3D
            Path { path in path.move(to: CGPoint(x: -size/2, y: -size/2)); path.addLine(to: CGPoint(x: -size/2 + depth, y: -size/2 + depth/2)); path.addLine(to: CGPoint(x: -size/2 + depth, y: size/2 + depth/2)); path.addLine(to: CGPoint(x: -size/2, y: size/2)); path.closeSubpath() }.fill(color.opacity(0.70)) // Más opaco
        }
    }
}

// --- Preview ---
#Preview {
    HomeView()
}
