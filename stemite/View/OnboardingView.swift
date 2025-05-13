import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    var selectedGender: WelcomeView.Gender? // Recibe el enum de WelcomeView
    let questions: [QuizQuestion]          // Recibe las preguntas

    @State private var currentPage = 0
    @State private var answersForEachPage: [UUID?] // Para el resaltado de cada página
    @State private var showFinalButton = false
    
    let backgroundColor = Color(red: 1.0, green: 0.98, blue: 0.96)
    let primaryTextColor = Color(red: 0.1, green: 0.1, blue: 0.1)

    // Inicializador ACEPTA questions
    init(hasCompletedOnboarding: Binding<Bool>, selectedGender: WelcomeView.Gender?, questions: [QuizQuestion]) {
        self._hasCompletedOnboarding = hasCompletedOnboarding
        self.selectedGender = selectedGender
        self.questions = questions
        _answersForEachPage = State(initialValue: Array(repeating: nil, count: questions.count))
    }

    var body: some View {
        if questions.isEmpty {
            Text("No hay preguntas de onboarding.")
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.hasCompletedOnboarding = true
                    }
                }
        } else {
            ZStack {
                backgroundColor.ignoresSafeArea()
                VStack {
            
                    TabView(selection: $currentPage) {
                        ForEach(questions.indices, id: \.self) { index in
                            OnboardingQuestionCard(
                                question: questions[index],
                                selectedOptionID: $answersForEachPage[index], // Binding al elemento del array
                                onOptionSelected: { _ in // El ID ya se guardó en answersForEachPage[index]
                                    if index == questions.count - 1 {
                                        if !showFinalButton {
                                            withAnimation { showFinalButton = true }
                                        }
                                    }
                                }
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

                    if showFinalButton && currentPage == questions.count - 1 {
                        Button(action: {
                            print("Onboarding completado. Género: \(selectedGender?.rawValue ?? "No especificado")")
                            self.hasCompletedOnboarding = true
                        }) {
                            Text("¡LISTO! VER MI FLOW")
                                .font(.custom("AvenirNext-Bold", size: 18))
                                .fontWeight(.bold).foregroundColor(.white).padding()
                                .frame(maxWidth: .infinity).background(Color.orange)
                                .cornerRadius(12).shadow(radius: 5)
                        }
                        .padding(.horizontal, 30).padding(.bottom, 30)
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    }
                    Spacer(minLength: (showFinalButton && currentPage == questions.count - 1) ? 20 : 70)
                }
            }
            .onChange(of: currentPage) { newPage in
                // No es necesario resetear `answersForEachPage[index]` aquí,
                // ya que cada página usa su propio elemento del array.
                if newPage < questions.count - 1 {
                    if showFinalButton {
                        withAnimation { showFinalButton = false }
                    }
                }
            }
        }
    }
}

// --- Subvistas para OnboardingView (OnboardingQuestionCard y OnboardingOptionCard) ---
// (Tu código para estas subvistas, asegurándote que OnboardingQuestionCard reciba
// `@Binding var selectedOptionID: UUID?` y OnboardingOptionCard reciba
// `let isSelected: Bool` y las use para el resaltado)

struct OnboardingQuestionCard: View {
    let question: QuizQuestion
    @Binding var selectedOptionID: UUID?
    let onOptionSelected: (UUID) -> Void
    let primaryTextColor = Color(red: 0.1, green: 0.1, blue: 0.1)

    var body: some View {
        VStack(spacing: 25) {
            Text(question.questionText)
                .font(.custom("AvenirNext-Bold", size: 26))
                .fontWeight(.bold).foregroundColor(primaryTextColor)
                .multilineTextAlignment(.center).padding(.horizontal, 20).padding(.top, 50)
            ForEach(question.options) { option in
                Button(action: {
                    selectedOptionID = option.id
                    onOptionSelected(option.id)
                }) { OnboardingOptionCard(option: option, isSelected: selectedOptionID == option.id) }
            }
            Spacer()
        }.padding(.bottom, 20)
    }
}

struct OnboardingOptionCard: View {
    let option: QuizOption
    let isSelected: Bool
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if UIImage(named: option.imageName) != nil { Image(option.imageName).resizable().aspectRatio(contentMode: .fill).frame(height: 140).clipped()
            } else { option.accentColor.opacity(0.3).frame(height: 140) }
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), .clear]), startPoint: .bottom, endPoint: .center).frame(height: 140)
            Text(option.text)
                .font(.custom("AvenirNext-DemiBold", size: 18)).fontWeight(.semibold).foregroundColor(.white).padding(12).shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 1)
        }
        .frame(height: 140).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? option.accentColor : Color.gray.opacity(0.3), lineWidth: isSelected ? 3.5 : 1.5))
        .scaleEffect(isSelected ? 1.02 : 1.0).animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .padding(.horizontal, 25)
    }
}


// --- Preview para OnboardingView (CORREGIDO) ---
struct OnboardingView_PreviewHelper: View {
    @State var onboardingCompleted_preview = false // Nombre diferente para el preview
    var body: some View {
        OnboardingView(
            hasCompletedOnboarding: $onboardingCompleted_preview,
            selectedGender: .mujer, // Ejemplo
            questions: sampleOnboardingQuestions // Pasa los datos globales
        )
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView_PreviewHelper()
    }
}
