import SwiftUI

struct WelcomeView: View {
    // Estado para manejar la solicitud de permisos de notificación (opcional para el MVP)
    @State private var showingNotificationAlert = false

    // Colores (puedes definirlos globalmente o aquí)
    let backgroundColor = Color(red: 1.0, green: 0.96, blue: 0.92) // Un durazno/salmón muy pálido
    let primaryTextColor = Color(red: 0.2, green: 0.2, blue: 0.2) // Un gris oscuro
    let accentColor = Color(red: 0.98, green: 0.6, blue: 0.23) // Naranja vibrante

    var body: some View {
        ZStack {
            // Fondo de la vista
            backgroundColor
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                // Logo y Nombre de la App (Placeholder)
                HStack {
                    Image(systemName: "hexagon.fill") // Placeholder para tu logo
                        .font(.title)
                        .foregroundColor(accentColor)
                    Text("STEMify") // Nombre de tu app
                        .font(.custom("AvenirNext-Bold", size: 28)) // Fuente moderna y audaz
                        .fontWeight(.bold)
                        .foregroundColor(primaryTextColor)
                }
                .padding(.top, 40) // Espacio desde la parte superior

                // Texto de Bienvenida Principal
                Text("¡Qué rollo, futur@ crack!")
                    .font(.custom("AvenirNext-Bold", size: 36))
                    .fontWeight(.heavy) // Muy audaz para impacto
                    .foregroundColor(primaryTextColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8) // Para que se ajuste si es muy largo

                // Subtexto
                Text("¿List@ para que STEMify te aviente al estrellato STEM? 😎 Pero tranqui, primero vamos a calar tu flow con unas preguntillas.")
                    .font(.custom("AvenirNext-Medium", size: 20))
                    .foregroundColor(primaryTextColor.opacity(0.8))
                    .lineSpacing(6) // Espacio entre líneas para legibilidad

                Spacer() // Empuja el botón hacia abajo

                // Botón Principal de Llamada a la Acción
                Button(action: {
                    // Acción para el botón:
                    // Aquí iría la navegación a la siguiente vista (`FlowDetectorQuestionView`)
                    // o la lógica para solicitar permisos de notificación primero.
                    // Para este ejemplo, simplemente imprimimos en consola.
                    print("¡VÁMONOS RECIO! presionado")
                    // Si quieres mostrar un alert para notificaciones:
                    // self.showingNotificationAlert = true
                }) {
                    Text("¡VÁMONOS RECIO!")
                        .font(.custom("AvenirNext-Bold", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 18)
                        .frame(maxWidth: .infinity) // Para que ocupe todo el ancho
                        .background(accentColor)
                        .cornerRadius(15) // Esquinas redondeadas
                        .shadow(color: accentColor.opacity(0.4), radius: 8, x: 0, y: 4) // Sombra sutil
                }
                .padding(.bottom, 40) // Espacio desde la parte inferior

            }
            .padding(.horizontal, 30) // Padding lateral para todo el VStack
        }
        // Opcional: Alerta para permisos de notificación
        // .alert(isPresented: $showingNotificationAlert) {
        //     Alert(
        //         title: Text("Permiso de Notificaciones"),
        //         message: Text("¿Nos das chance de mandarte notis pa' que no te pierdas los secretos y recompensas?"),
        //         primaryButton: .default(Text("¡Simón!"), action: {
        //             // Lógica para solicitar permisos de notificación
        //             UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        //                 if granted {
        //                     print("Permiso de notificación concedido")
        //                 } else if let error = error {
        //                     print("Error en permiso de notificación: \(error.localizedDescription)")
        //                 }
        //             }
        //         }),
        //         secondaryButton: .cancel(Text("Nel, gracias"))
        //     )
        // }
    }
}

// Para la previsualización en Xcode
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
