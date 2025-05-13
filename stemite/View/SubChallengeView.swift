import SwiftUI

// ASUMIMOS QUE TUS MODELOS AnswerOption y SubChallenge ESTÁN EN Missions.swift
// Y SON ACCESIBLES.
// También que tu `sampleSubChallenge` (o los datos que le pases) están bien definidos.

struct SubChallengeDetailView: View {
    let subChallenge: SubChallenge
    let onSubChallengeCompleted: () -> Void // Callback para avanzar

    @State private var selectedOptionID: UUID?
    @State private var showFeedback = false
    @State private var answerIsCorrect: Bool? = nil
    @State private var showExplanationSheet = false
    
    // Para controlar el timer del avance automático
    @State private var autoAdvanceTimer: Timer? = nil
    // Para saber si el usuario abrió la explicación y evitar doble avance
    @State private var explanationSheetWasShown = false

    @Environment(\.dismiss) var dismiss // Se usa si esta vista es presentada como un sheet/fullScreenCover individualmente

    // --- Paleta de Colores (Tomada de tu código) ---
    let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.97)
    let primaryTextColor = Color(red: 0.1, green: 0.1, blue: 0.12)
    let secondaryTextColor = Color(red: 0.4, green: 0.4, blue: 0.43)
    let accentOrange = Color(red: 1.0, green: 0.48, blue: 0.0)
    let accentGreen = Color(red: 0.22, green: 0.80, blue: 0.08)
    let correctColor: Color
    let incorrectColor = Color(red: 0.90, green: 0.22, blue: 0.21)
    let buttonTextColor = Color.white // Aunque ya no hay botón de continuar, lo dejamos por si se usa en el de explicación
    let optionBackgroundColor = Color.white
    let optionBorderColor = Color.gray.opacity(0.25)

    init(subChallenge: SubChallenge, onSubChallengeCompleted: @escaping () -> Void) {
        self.subChallenge = subChallenge
        self.onSubChallengeCompleted = onSubChallengeCompleted
        self.correctColor = accentGreen // El verde del mock es el color de "correcto"
    }
    
    private func handleOptionSelection(option: AnswerOption) {
        guard answerIsCorrect == nil else { return } // Solo procesar una vez

        selectedOptionID = option.id
        answerIsCorrect = option.isCorrect
        withAnimation(.interpolatingSpring(stiffness: 170, damping: 12)) {
            showFeedback = true
        }

        // Cancela cualquier timer anterior
        autoAdvanceTimer?.invalidate()
        explanationSheetWasShown = false // Resetea esto cada vez que se responde

        // Inicia un timer para el avance automático DESPUÉS de mostrar el feedback.
        // Si el usuario abre la explicación, este timer se cancelará.
        let advanceDelay: TimeInterval = (answerIsCorrect ?? false) ? 2.0 : 3.5 // Un poco más de tiempo si es incorrecta para leer el feedback y decidir si ver "¿Kha?"
        
        autoAdvanceTimer = Timer.scheduledTimer(withTimeInterval: advanceDelay, repeats: false) { _ in
            // Solo avanza si el sheet de explicación NO está actualmente mostrándose.
            // Si el usuario abrió y cerró el sheet, explanationSheetWasShown sería true, y el avance se haría en onDismiss.
            if !showExplanationSheet && !explanationSheetWasShown {
                onSubChallengeCompleted()
            }
        }
    }
    
    private func handleExplanationButton() {
        autoAdvanceTimer?.invalidate() // Detener el avance automático si el usuario quiere ver la explicación
        explanationSheetWasShown = true // Marcar que el usuario va a ver/vio la explicación
        showExplanationSheet = true
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                // 1. Header (Tu código actual del header)
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(subChallenge.missionTitle.uppercased())
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(secondaryTextColor)
                            .kerning(0.5)
                        ProgressView(value: Double(subChallenge.currentStep), total: Double(subChallenge.totalSteps))
                            .progressViewStyle(LinearProgressViewStyle(tint: accentOrange)) // Consistente con botones
                            .frame(height: 5)
                            .scaleEffect(x: 1, y: 1.0, anchor: .center)
                            .clipShape(Capsule())
                    }
                    Spacer()
                    Button(action: { print("Botón Reportar presionado") }) {
                        Image(systemName: "flag")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(secondaryTextColor.opacity(0.7))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, (UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.top ?? 0) > 20 ? 5 : 15)
                .padding(.bottom, 6)

                Text("Reto \(subChallenge.currentStep) de \(subChallenge.totalSteps)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(secondaryTextColor)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 18)
                
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // 2. Área de Contexto (Tu código actual)
                            HStack(alignment: .center, spacing: 10) {
                                Image(systemName: subChallenge.contextIconName ?? "gearshape.fill")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(accentOrange)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(subChallenge.contextTitle)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(primaryTextColor)
                                    Text(subChallenge.contextText)
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(secondaryTextColor)
                                        .lineSpacing(3)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 25)

                            // 3. Pregunta Principal (Tu código actual)
                            Text(subChallenge.questionText)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(primaryTextColor)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                .multilineTextAlignment(.leading)
                                .id("QuestionTextID")

                            // Opciones de Respuesta (Tu código actual)
                            VStack(spacing: 10) {
                                ForEach(subChallenge.options) { option in
                                    Button(action: {
                                        handleOptionSelection(option: option)
                                    }) {
                                        // ASUMIMOS QUE OptionCardView ESTÁ DEFINIDA EN OTRO LADO
                                        // O DENTRO DE ESTE ARCHIVO COMO SUBVISTA
                                        OptionCardView(
                                            option: option,
                                            isSelected: selectedOptionID == option.id,
                                            answerState: answerIsCorrect,
                                            correctColor: correctColor,
                                            incorrectColor: incorrectColor,
                                            defaultBorderColor: optionBorderColor,
                                            defaultBackgroundColor: optionBackgroundColor,
                                            primaryTextColor: primaryTextColor
                                        )
                                    }
                                    .disabled(answerIsCorrect != nil)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 25)

                            // 4. Sección de Feedback (Tu código actual)
                            if showFeedback {
                                // ASUMIMOS QUE FeedbackView ESTÁ DEFINIDA EN OTRO LADO
                                // O DENTRO DE ESTE ARCHIVO COMO SUBVISTA
                                FeedbackView(
                                    isCorrect: answerIsCorrect ?? false,
                                    xpReward: subChallenge.xpReward,
                                    correctColor: correctColor,
                                    primaryTextColor: primaryTextColor,
                                    accentGreen: accentGreen
                                )
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                .onAppear {
                                    withAnimation {
                                        scrollViewProxy.scrollTo("FeedbackAreaID", anchor: .bottom)
                                    }
                                }
                                .id("FeedbackAreaID")
                            }
                        } // Fin VStack ScrollView
                    } // Fin ScrollView
                } // Fin ScrollViewReader
                
                Spacer() // Asegura que el botón "¿Kha?" se quede abajo si el contenido es corto

                // 5. Botón "¿Kha? (Explicación)"
                // Solo se muestra si ya se respondió (showFeedback = true)
                if showFeedback {
                    Button(action: handleExplanationButton) {
                        Text("¿Kha? (Explicación)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(accentOrange)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                 RoundedRectangle(cornerRadius: 10)
                                     .stroke(accentOrange, lineWidth: 1.5)
                             )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, (UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.bottom ?? 0) > 0 ? 15 : 25) // Ajuste para safe area
                    .transition(.opacity.combined(with: .offset(y: 10))) // Animación para que aparezca
                }
            } // Fin VStack Principal
        } // Fin ZStack
        .sheet(isPresented: $showExplanationSheet, onDismiss: {
            // Cuando se cierra el sheet de explicación, SIEMPRE avanzamos al siguiente reto.
            // El timer (si se inició) ya habrá sido invalidado al abrir el sheet.
            onSubChallengeCompleted()
        }) {
            // ASUMIMOS QUE ExplanationView ESTÁ DEFINIDA EN OTRO LADO
            // O DENTRO DE ESTE ARCHIVO COMO SUBVISTA
            ExplanationView(text: subChallenge.explanationText, accentColor: accentOrange)
        }
        .onDisappear {
            // Invalida el timer si la vista desaparece por otra razón
            // (ej. si el usuario navega hacia atrás bruscamente, aunque el flujo es hacia adelante)
            autoAdvanceTimer?.invalidate()
        }
    }
}

// MARK: - Subvistas (Asegúrate de tener estas definiciones como te las pasé, con los ajustes al mock)

struct OptionCardView: View {
    let option: AnswerOption
    let isSelected: Bool
    let answerState: Bool?
    
    let correctColor: Color
    let incorrectColor: Color
    let defaultBorderColor: Color
    let defaultBackgroundColor: Color
    let primaryTextColor: Color

    var iconName: String { option.iconName ?? "questionmark.square.dashed" }
    var iconColor: Color {
        let effectiveBorderColor = determineEffectiveBorderColor()
        if isSelected && answerState != nil {
            if option.isCorrect { return correctColor }
            if isSelected && !option.isCorrect { return incorrectColor }
        }
        return primaryTextColor.opacity(0.6)
    }

    func determineEffectiveBorderColor() -> Color {
        guard isSelected, let _ = answerState else { return defaultBorderColor }
        if option.isCorrect { return correctColor }
        if !option.isCorrect && isSelected { return incorrectColor }
        return defaultBorderColor
    }
    func determineEffectiveBackgroundColor() -> Color { return defaultBackgroundColor }
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName)
                .font(.system(size: 18, weight: .medium)) // AJUSTA FUENTE
                .foregroundColor(iconColor)
                .frame(width: 24, alignment: .center)
            Text(option.text)
                .font(.system(size: 14, weight: .medium)) // AJUSTA FUENTE
                .foregroundColor(primaryTextColor)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
            Spacer()
            if isSelected && answerState != nil {
                if option.isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(correctColor)
                        .font(.system(size: 20, weight: .semibold))
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(incorrectColor)
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .frame(minHeight: 50)
        .background(determineEffectiveBackgroundColor())
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(determineEffectiveBorderColor(), lineWidth: 1.5))
    }
}

struct FeedbackView: View {
    let isCorrect: Bool
    let xpReward: Int
    let correctColor: Color
    let primaryTextColor: Color
    let accentGreen: Color

    var body: some View {
        VStack(spacing: 6) {
            if isCorrect {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill").foregroundColor(Color.yellow).font(.system(size: 18, weight: .medium)) // AJUSTA
                    Text("¡A HUEVO! Le atinaste, crack.").font(.system(size: 15, weight: .bold)).foregroundColor(correctColor) // AJUSTA
                }
                Text("+ \(xpReward) XP ✨").font(.system(size: 13, weight: .semibold)).foregroundColor(primaryTextColor) // AJUSTA
                    .padding(.vertical, 5).padding(.horizontal, 10)
                    .background(accentGreen.opacity(0.2)).clipShape(Capsule())
            } else {
                HStack(spacing: 6) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(Color.red.opacity(0.8)).font(.system(size: 18, weight: .medium)) // AJUSTA
                    Text("¡Valió queso! Pero tranqui, checa la info.").font(.system(size: 15, weight: .bold)).foregroundColor(Color.red.opacity(0.8)) // AJUSTA
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 5)
        .transition(.opacity.combined(with: .offset(y: -5)))
    }
}

struct ExplanationView: View {
    let text: String
    let accentColor: Color
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("¡Más Choro Pa' que le Caches Bien!")
                        .font(.system(size: 22, weight: .bold)).foregroundColor(accentColor).padding(.bottom, 5) // AJUSTA
                    Text(text)
                        .font(.system(size: 16, weight: .regular)).lineSpacing(5) // AJUSTA
                    Spacer()
                }.padding()
            }
            .navigationTitle("Explicación").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { // Usar .navigationBarTrailing para el botón "Hecho"
                    Button("Hecho") { dismiss() }.foregroundColor(accentColor).fontWeight(.semibold)
                }
            }
        }
    }
}

// --- Preview ---
struct SubChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let previewChallenge = SubChallenge( // Asegúrate que este sample data esté actualizado
            missionTitle: "El Código Secreto de los Likes",
            currentStep: 1, totalSteps: 2,
            contextIconName: "lightbulb.fill", contextTitle: "El Algoritmo Chismoso",
            contextText: "¿No te saca de pedo que TikTok te aviente justo el video que querías ver? No es que te lean la mente (o bueno, casi). ¡Son los algoritmos, esos compas invisibles! Vamos a ver cómo jalan...",
            questionText: "Si el algoritmo ve que a un usuario le MAMA el K-Pop y los videos de gatitos con outfits chistosos, ¿cuál de estos videos crees que le aventaría después para que se quede PICADO?",
            options: [
                AnswerOption(text: "Video de recetas de cocina con música clásica 🥱", iconName: "fork.knife.circle.fill"),
                AnswerOption(text: "Un gatito bailando K-Pop con un outfit ridículo 😹🎶", iconName: "cat.fill", isCorrect: true),
                AnswerOption(text: "Noticiero sobre economía global 📊", iconName: "chart.line.uptrend.xyaxis.circle.fill")
            ],
            explanationText: "¡Exacto! Los algoritmos buscan patrones...", xpReward: 25
        )
        SubChallengeDetailView(subChallenge: previewChallenge) {
            print("Preview: SubChallenge completado y avanzaría.")
        }
    }
}
