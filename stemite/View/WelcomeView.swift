import SwiftUI

struct WelcomeView: View {
    // Estado para controlar la presentación de la siguiente vista (onboarding)
    @State private var navigateToOnboarding = false

    // Colores (puedes definirlos globalmente o aquí)
    let backgroundColor = Color(red: 1.0, green: 0.96, blue: 0.92) // Un durazno/salmón muy pálido
    let primaryTextColor = Color(red: 0.2, green: 0.2, blue: 0.2) // Un gris oscuro
    let accentColor = Color(red: 0.98, green: 0.6, blue: 0.23) // Naranja vibrante

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                // Logo y Nombre de la App
                HStack {
                    Image(systemName: "hexagon.fill") // Placeholder para tu logo
                        .font(.title)
                        .foregroundColor(accentColor)
                    Text("STEMify") // Nombre de tu app
                        .font(.custom("AvenirNext-Bold", size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(primaryTextColor)
                }
                .padding(.top, 40)

                // Texto de Bienvenida Principal
                Text("¡Qué rollo, futur@ crack!")
                    .font(.custom("AvenirNext-Bold", size: 36))
                    .fontWeight(.heavy)
                    .foregroundColor(primaryTextColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                // Subtexto
                Text("¿List@ para que STEMify te aviente al estrellato STEM? 😎 Pero tranqui, primero vamos a calar tu flow con unas preguntillas.")
                    .font(.custom("AvenirNext-Medium", size: 20))
                    .foregroundColor(primaryTextColor.opacity(0.8))
                    .lineSpacing(6)

                Spacer() // Empuja el botón hacia abajo

                // Botón Principal de Llamada a la Acción
                Button(action: {
                    // Al presionar el botón, cambiamos el estado para mostrar el onboarding
                    self.navigateToOnboarding = true
                }) {
                    Text("¡VÁMONOS RECIO!")
                        .font(.custom("AvenirNext-Bold", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity)
                        .background(accentColor)
                        .cornerRadius(15)
                        .shadow(color: accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 30)
        }
        // Modificador para presentar la FlowDetectorPageView como un modal de pantalla completa
        .fullScreenCover(isPresented: $navigateToOnboarding) {
            OnboardingView() // Esta es la vista con las preguntas deslizables
        }
    }
}

// Para la previsualización en Xcode
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
