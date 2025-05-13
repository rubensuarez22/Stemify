import SwiftUI

struct WelcomeView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var navigateToOnboarding = false
    @State private var selectedGender: Gender? = nil
    @State private var showGenderError = false

    // Define Gender DENTRO de WelcomeView o globalmente si otras vistas la necesitan.
    // Si es global, muévela a Models/Missions.swift.
    enum Gender: String, CaseIterable, Identifiable {
        case hombre = "Hombre"
        case mujer = "Mujer"
        case otro = "No binario"
        case prefierNoDecir = "Prefiero no decir"
        var id: String { self.rawValue }
    }
    
    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea() // Asegúrate que Color.cream esté definido
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "hexagon.fill").font(.title).foregroundColor(Color.primaryOrange)
                    Text("STEMify").font(.custom("AvenirNext-Bold", size: 28)).fontWeight(.bold).foregroundColor(Color.primaryTextColor)
                }.padding(.top, 40)
                
                Text("¡Qué rollo, futur@ crack!")
                    .font(.custom("AvenirNext-Bold", size: 36)).fontWeight(.heavy).foregroundColor(Color.primaryTextColor)
                    .lineLimit(2).minimumScaleFactor(0.8)
                
                Text("¿List@ para que STEMify te aviente al estrellato STEM? 😎 Pero tranqui, primero vamos a calar tu flow con unas preguntillas.")
                    .font(.custom("AvenirNext-Medium", size: 20)).foregroundColor(Color.primaryTextColor.opacity(0.8)).lineSpacing(6)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("¿Con cuál género te identificas?")
                        .font(.custom("AvenirNext-DemiBold", size: 18)).foregroundColor(Color.primaryTextColor)
                    HStack(spacing: 10) {
                        ForEach(Gender.allCases.prefix(2)) { gender in
                            GenderButton(gender: gender, isSelected: selectedGender == gender, accentColor: Color.primaryOrange, action: { selectedGender = gender })
                        }
                    }
                    HStack(spacing: 10) {
                        ForEach(Gender.allCases.suffix(2)) { gender in
                            GenderButton(gender: gender, isSelected: selectedGender == gender, accentColor: Color.primaryOrange, action: { selectedGender = gender })
                        }
                    }
                    if showGenderError {
                        Text("Por favor selecciona una opción para continuar")
                            .font(.caption).foregroundColor(.red).padding(.top, 5)
                    }
                }.padding(.top, 10)
                
                Spacer()
                
                Button(action: {
                    if selectedGender != nil {
                        self.navigateToOnboarding = true
                        self.showGenderError = false
                    } else {
                        self.showGenderError = true
                    }
                }) {
                    Text("¡VÁMONOS RECIO!")
                        .font(.custom("AvenirNext-Bold", size: 20)).fontWeight(.bold).foregroundColor(.white)
                        .padding(.vertical, 18).frame(maxWidth: .infinity).background(Color.primaryOrange)
                        .cornerRadius(15).shadow(color: Color.primaryOrange.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 30)
        }
        .fullScreenCover(isPresented: $navigateToOnboarding) {
            // Pasa TODOS los parámetros que OnboardingView espera en su init
            OnboardingView(
                hasCompletedOnboarding: $hasCompletedOnboarding,
                selectedGender: selectedGender,
                questions: sampleOnboardingQuestions // <--- Pasa los datos aquí
            )
        }
    }
}

struct GenderButton: View {
    let gender: WelcomeView.Gender // Ahora usa el enum local de WelcomeView
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(gender.rawValue)
                .font(.custom("AvenirNext-Medium", size: 16))
                .padding(.vertical, 12).frame(maxWidth: .infinity)
                .background(isSelected ? accentColor : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? accentColor : Color.gray.opacity(0.3), lineWidth: 1))
        }
    }
}

struct WelcomeView_PreviewHelper: View {
     @State var onboardingCompleted_preview = false
     var body: some View {
         WelcomeView(hasCompletedOnboarding: $onboardingCompleted_preview)
     }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView_PreviewHelper()
    }
}
