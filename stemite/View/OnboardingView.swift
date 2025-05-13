import SwiftUI

// --- Modelos de Datos para las Preguntas y Opciones ---
struct QuizQuestion: Identifiable, Hashable {
    let id = UUID()
    let questionText: String
    let options: [QuizOption]
    // Puedes añadir un campo para el tipo de "aspiración" que representa la pregunta
    // let aspirationType: String // Ej: "Gaming", "Creator", "Strategist"
}

struct QuizOption: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let imageName: String // Nombre de la imagen en tus assets
    let accentColor: Color // Color para el borde/feedback
}

// --- Vista Principal del Quiz con Paginación ---
struct OnboardingView: View {
    // Estado para la página actual del TabView
    @State private var currentPage = 0
    // Estado para almacenar las respuestas (opcional, depende de si necesitas guardarlas)
    @State private var answers: [UUID?] // Almacena el ID de la opción seleccionada para cada pregunta

    // Datos de ejemplo para las preguntas
    // DEBES REEMPLAZAR ESTO CON TUS PREGUNTAS REALES Y ASSETS
    let questions: [QuizQuestion] = [
        QuizQuestion(questionText: "¿Qué 'vida de pro' te llama más la atención? ✨🔥",
                     options: [
                        QuizOption(text: "REVENTARLA COMO STREAMER PRO", imageName: "streamer_setup", accentColor: Color.green), // Reemplaza "streamer_setup"
                        QuizOption(text: "DISEÑAR LOS JUEGOS DEL MAÑANA", imageName: "game_design_concept", accentColor: Color.orange), // Reemplaza "game_design_concept"
                        QuizOption(text: "SER EL CEREBRO DETRÁS DEL PRÓXIMO HIT", imageName: "tech_brain_matrix", accentColor: Color.blue) // Reemplaza "tech_brain_matrix"
                     ]),
        QuizQuestion(questionText: "Si tuvieras un día libre y $1000, ¿en qué los gastarías? 💸🤔",
                     options: [
                        QuizOption(text: "EL MEJOR EQUIPO GAMER", imageName: "gamer_gear", accentColor: Color.purple),
                        QuizOption(text: "CURSOS PARA CREAR ALGO ÉPICO", imageName: "online_courses", accentColor: Color.yellow),
                        QuizOption(text: "INVERTIR PARA MÁS LANA", imageName: "investment_chart", accentColor: Color.cyan)
                     ]),
        QuizQuestion(questionText: "¿Qué te emociona más de la tecnología del futuro? 👽🚀",
                     options: [
                        QuizOption(text: "REALIDAD VIRTUAL INMERSIVA", imageName: "vr_world", accentColor: Color.red),
                        QuizOption(text: "INTELIGENCIA ARTIFICIAL QUE LO RESUELVA TODO", imageName: "ai_brain_gears", accentColor: Color.teal),
                        QuizOption(text: "VIAJES ESPACIALES ACCESIBLES", imageName: "space_travel", accentColor: Color.pink)
                     ])
        // Añade más preguntas aquí
    ]

    // Colores de la app (puedes pasarlos o definirlos aquí)
    let backgroundColor = Color(red: 1.0, green: 0.98, blue: 0.96) // Un fondo muy pálido, casi blanco
    let primaryTextColor = Color(red: 0.1, green: 0.1, blue: 0.1) // Casi negro para el texto

    // Estado para la opción seleccionada en la pregunta actual
    @State private var selectedOptionID: UUID?
    // Estado para mostrar el botón final
    @State private var showFinalButton = false

    init() {
        // Inicializar el array de respuestas con nil para cada pregunta
        _answers = State(initialValue: Array(repeating: nil, count: questions.count))
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack {
                // Paginador de Preguntas
                TabView(selection: $currentPage) {
                    ForEach(questions.indices, id: \.self) { index in
                        QuestionView(
                            question: questions[index],
                            questionNumber: index + 1,
                            totalQuestions: questions.count,
                            selectedOptionID: $answers[index], // Enlaza la selección de esta pregunta
                            isLastQuestion: index == questions.count - 1,
                            onOptionSelected: { optionID in
                                answers[index] = optionID // Guarda la respuesta
                                if index == questions.count - 1 { // Si es la última pregunta
                                    withAnimation {
                                        showFinalButton = true
                                    }
                                } else {
                                    // Avanzar a la siguiente página automáticamente (opcional)
                                    // withAnimation {
                                    //     currentPage = min(currentPage + 1, questions.count - 1)
                                    // }
                                }
                            }
                        )
                        .tag(index) // Importante para que el TabView funcione
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Estilo de paginación con puntos
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // Para que los puntos siempre se vean

                // Botón Final (aparece sutilmente en la última pregunta después de seleccionar una opción)
                if showFinalButton && currentPage == questions.count - 1 {
                    Button(action: {
                        // Acción final: Navegar a la siguiente sección de la app (Misiones)
                        // Aquí procesarías las `answers` si es necesario
                        print("Quiz completado. Respuestas: \(answers)")
                        // Lógica de navegación...
                    }) {
                        Text("¡LISTO! VER MI FLOW")
                            .font(.custom("AvenirNext-Bold", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange) // Color del botón final, ajústalo
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                    .transition(.opacity.combined(with: .scale(scale: 0.9))) // Animación sutil
                }

                Spacer(minLength: showFinalButton && currentPage == questions.count - 1 ? 10 : 60) // Ajusta el espacio si el botón está visible
            }
        }
    }
}

// --- Vista para cada Pregunta Individual ---
struct QuestionView: View {
    let question: QuizQuestion
    let questionNumber: Int
    let totalQuestions: Int
    @Binding var selectedOptionID: UUID? // Enlace a la opción seleccionada
    let isLastQuestion: Bool
    let onOptionSelected: (UUID) -> Void // Callback cuando se selecciona una opción

    // Colores (puedes pasarlos o definirlos aquí también)
    let primaryTextColor = Color(red: 0.1, green: 0.1, blue: 0.1)

    var body: some View {
        VStack(spacing: 25) {
            // Texto de la Pregunta
            Text(question.questionText)
                .font(.custom("AvenirNext-Bold", size: 26))
                .fontWeight(.bold)
                .foregroundColor(primaryTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 40) // Más espacio arriba

            // Opciones
            ForEach(question.options) { option in
                Button(action: {
                    selectedOptionID = option.id // Actualiza la selección
                    onOptionSelected(option.id) // Llama al callback
                }) {
                    OptionView(
                        option: option,
                        isSelected: selectedOptionID == option.id
                    )
                }
            }
            Spacer() // Empuja las opciones hacia arriba si hay pocas
        }
        .padding(.bottom, 20) // Padding inferior para la vista de pregunta
    }
}

// --- Vista para cada Opción ---
struct OptionView: View {
    let option: QuizOption
    let isSelected: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Imagen de Fondo de la Opción
            // DEBES TENER ESTAS IMÁGENES EN TUS ASSETS
            Image(option.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill) // O .fit, según prefieras
                .frame(height: 150) // Altura fija para las tarjetas de opción
                .clipped() // Para que la imagen no se salga del frame

            // Overlay oscuro para que el texto resalte
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.8), Color.black.opacity(0.2), Color.clear]),
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(height: 150)

            // Texto de la Opción
            Text(option.text)
                .font(.custom("AvenirNext-DemiBold", size: 18))
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(15)
                .shadow(color: .black.opacity(0.7), radius: 3, x: 1, y: 1) // Sombra para el texto
        }
        .frame(height: 150)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? option.accentColor : Color.gray.opacity(0.5), lineWidth: isSelected ? 4 : 2) // Borde de selección
        )
        .scaleEffect(isSelected ? 1.03 : 1.0) // Efecto sutil al seleccionar
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .padding(.horizontal, 20)
    }
}

// --- Preview ---
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
