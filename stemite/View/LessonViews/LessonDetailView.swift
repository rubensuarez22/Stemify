import SwiftUI

// ASUME QUE 'Lesson' y 'LessonType' están definidas globalmente o en un archivo de Modelos importado.
// Ejemplo:
// enum LessonType { case standard, checkpoint, locked }
// struct Lesson: Identifiable { /* ... tus campos ... */ }

struct LessonDetailView: View {
    let lesson: Lesson
    @Environment(\.dismiss) var dismiss // Para iOS 15+ (o @Environment(\.presentationMode) var presentationMode para versiones anteriores)

    var body: some View {
        NavigationView { // Para el título y el botón de cierre
            VStack(spacing: 20) {
                // Header with animated character (tu código actual)
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    lesson.isCompleted ? Color.green : Color.blue,
                                    lesson.isCompleted ? Color.green.opacity(0.7) : Color.blue.opacity(0.7)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 200)
                    
                    VStack {
                        Image(systemName: "person.fill") // Placeholder, usa tu imagen/animación
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80) // Ajustado
                            .foregroundColor(.white)
                            .padding(15)
                            .background(Color.white.opacity(0.2).clipShape(Circle()))
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        
                        Text(lesson.title)
                            .font(.system(size: 24, weight: .bold)) // Ajustado
                            .foregroundColor(.white)
                            .padding(.top, 8)
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: 15) { // Ajustado spacing
                    Text("Elige un ejercicio:") // Cambiado el texto
                        .font(.system(size: 20, weight: .bold)) // Ajustado
                        .padding(.horizontal) // Añadido padding horizontal
                    
                    // Exercise options
                    // TÚ ACCIÓN: Reemplaza este ForEach con tu lógica real de ejercicios para la lección
                    ForEach(1...3, id: \.self) { index in
                        ExerciseRow( // <<--- ESTA ES LA LLAMADA
                            title: "Ejercicio \(index)",
                            description: "Practica: \(lesson.title.lowercased())"
                        )
                        .padding(.horizontal) // Añadido padding horizontal
                    }
                    
                    Spacer()
                    
                    // Start button (o botón de continuar si ya hay ejercicios)
                    Button(action: {
                        // Lógica para empezar la lección o el primer ejercicio
                        print("Start Lesson/Exercise for: \(lesson.title)")
                    }) {
                        Text("Comenzar Lección") // Texto cambiado
                            .font(.system(size: 18, weight: .bold)) // Ajustado
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient( // Usando tu gradiente del mock
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.4), radius: 4, x: 0, y: 2) // Sombra ajustada
                    }
                    .padding() // Padding alrededor del botón
                }
                //.padding() // Quitado este padding general para ajustar el de los hijos
            }
            //.navigationTitle(lesson.title) // El título ya está en el header ZStack
            .navigationBarTitleDisplayMode(.inline) // Para que no muestre título grande si no quieres
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { // Cambiado a .navigationBarLeading para el 'xmark'
                    Button(action: {
                        dismiss() // Usa dismiss para iOS 15+
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold)) // Ajustado
                            .foregroundColor(Color.primary) // Color primario del sistema
                            .padding(8)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}

// MARK: - ExerciseRow Definition (PEGAR AQUÍ o definir en archivo de Modelos/Subvistas)
// Esta es la struct que te faltaba en el scope de LessonDetailView.swift

struct ExerciseRow: View {
    let title: String
    let description: String
    
    // TÚ ACCIÓN: Define colores y fuentes consistentes con tu app
    let iconBackgroundColor = Color.blue.opacity(0.1)
    let iconForegroundColor = Color.blue
    let textColor = Color.primary
    let subTextColor = Color.gray
    let arrowColor = Color.gray
    let cardBackgroundColor = Color.white
    let cardShadowColor = Color.black.opacity(0.05)

    var body: some View {
        Button(action: {
            // Acción al tocar la fila del ejercicio, ej. navegar al ejercicio
            print("Ejercicio seleccionado: \(title)")
        }) {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconBackgroundColor)
                        .frame(width: 44, height: 44) // Ajustado
                    
                    Image(systemName: "book.fill") // O un ícono específico por ejercicio
                        .font(.system(size: 20)) // Ajustado
                        .foregroundColor(iconForegroundColor)
                }
                
                VStack(alignment: .leading, spacing: 3) { // Ajustado spacing
                    Text(title)
                        .font(.system(size: 16, weight: .semibold)) // Ajustado
                        .foregroundColor(textColor)
                    
                    Text(description)
                        .font(.system(size: 13, weight: .regular)) // Ajustado
                        .foregroundColor(subTextColor)
                        .lineLimit(2) // Permitir que el texto se ajuste
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(arrowColor.opacity(0.7)) // Más sutil
            }
            .padding(12) // Padding interno de la tarjeta
            .background(cardBackgroundColor)
            .cornerRadius(10) // Radio más pequeño
            .shadow(color: cardShadowColor, radius: 3, x: 0, y: 1) // Sombra más sutil
        }
        .buttonStyle(PlainButtonStyle()) // Para que todo el HStack sea el área de toque del botón
    }
}

// --- Preview para LessonDetailView ---
// Asegúrate de que `Lesson` y `LessonType` estén definidas como en tu proyecto
// (idealmente en Models/Missions.swift o similar)

struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(lesson: Lesson(id: 1, title: "Aprendiendo Patrones Cool", isCompleted: false, icon: "square.stack.3d.up.fill", type: .standard))
    }
}
