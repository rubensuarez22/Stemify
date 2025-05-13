import SwiftUI

struct WelcomeView: View {
    // Estado para controlar la presentación de la siguiente vista (onboarding)
    @State private var navigateToOnboarding = false
    
    // Estado para almacenar la selección de género
    @State private var selectedGender: Gender? = nil
    @State private var showGenderError = false
    
    // Enumeración para los tipos de género
    enum Gender: String, CaseIterable, Identifiable {
        case hombre = "Hombre"
        case mujer = "Mujer"
        case otro = "No binario"
        case prefierNoDecir = "Prefiero no decir"
        
        var id: String { self.rawValue }
    }

    
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Logo y Nombre de la App
                HStack {
                    Image(systemName: "hexagon.fill") // Placeholder para tu logo
                        .font(.title)
                        .foregroundColor(Color.primaryOrange)
                    Text("STEMify") // Nombre de tu app
                        .font(.custom("AvenirNext-Bold", size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(Color.primaryTextColor)
                }
                .padding(.top, 40)
                
                // Texto de Bienvenida Principal
                Text("¡Qué rollo, futur@ crack!")
                    .font(.custom("AvenirNext-Bold", size: 36))
                    .fontWeight(.heavy)
                    .foregroundColor(Color.primaryTextColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                // Subtexto
                Text("¿List@ para que STEMify te aviente al estrellato STEM? 😎 Pero tranqui, primero vamos a calar tu flow con unas preguntillas.")
                    .font(.custom("AvenirNext-Medium", size: 20))
                    .foregroundColor(Color.primaryTextColor.opacity(0.8))
                    .lineSpacing(6)
                
                // Sección de selección de género
                VStack(alignment: .leading, spacing: 12) {
                    Text("¿Con cuál género te identificas?")
                        .font(.custom("AvenirNext-DemiBold", size: 18))
                        .foregroundColor(Color.primaryTextColor)
                    
                    // Botones de selección de género
                    HStack(spacing: 10) {
                        ForEach(Gender.allCases.prefix(2)) { gender in
                            GenderButton(
                                gender: gender,
                                isSelected: selectedGender == gender,
                                accentColor: Color.primaryOrange,
                                action: { selectedGender = gender }
                            )
                        }
                    }
                    
                    HStack(spacing: 10) {
                        ForEach(Gender.allCases.suffix(2)) { gender in
                            GenderButton(
                                gender: gender,
                                isSelected: selectedGender == gender,
                                accentColor: Color.primaryOrange,
                                action: { selectedGender = gender }
                            )
                        }
                    }
                    
                    // Mensaje de error (visible solo si se intenta continuar sin seleccionar género)
                    if showGenderError {
                        Text("Por favor selecciona una opción para continuar")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    }
                }
                .padding(.top, 10)
                
                Spacer() // Empuja el botón hacia abajo
                
                // Botón Principal de Llamada a la Acción
                Button(action: {
                    if selectedGender != nil {
                        // Al presionar el botón con género seleccionado, mostramos el onboarding
                        self.navigateToOnboarding = true
                        self.showGenderError = false
                    } else {
                        // Mostrar error si no se ha seleccionado género
                        self.showGenderError = true
                    }
                }) {
                    Text("¡VÁMONOS RECIO!")
                        .font(.custom("AvenirNext-Bold", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                        .background(Color.primaryOrange)
                        .cornerRadius(15)
                        .shadow(color: Color.primaryOrange.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 30)
        }
        // Modificador para presentar la FlowDetectorPageView como un modal de pantalla completa
        .fullScreenCover(isPresented: $navigateToOnboarding) {
            OnboardingView(selectedGender: selectedGender) // Pasamos el género seleccionado
        }
    }
}

// Componente para botón de selección de género
struct GenderButton: View {
    let gender: WelcomeView.Gender
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(gender.rawValue)
                .font(.custom("AvenirNext-Medium", size: 16))
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(isSelected ? accentColor : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? accentColor : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// Para la previsualización en Xcode
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
