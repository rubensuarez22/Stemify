import SwiftUI

// DENTRO DE TU MissionPlayerView.swift (o como la llames)

struct MissionPlayerView: View {
    // Suponiendo que tienes un ViewModel o una forma de acceder a todas las misiones
    @State var allMissions: [[SubChallenge]] = todasLasMisionesDisponibles // Usando los datos de arriba
    
    @State private var currentGlobalChallengeIndex: Int = 0 // Un índice global para simplificar
    @State private var totalChallengesAvailable: Int
    
    @Environment(\.dismiss) var dismiss

    init(initialMissions: [[SubChallenge]] = todasLasMisionesDisponibles) {
        _allMissions = State(initialValue: initialMissions)
        // Calcular el total de retos disponibles en todas las misiones
        _totalChallengesAvailable = State(initialValue: initialMissions.flatMap { $0 }.count)
    }

    func getCurrentSubChallenge() -> SubChallenge? {
        let flatChallenges = allMissions.flatMap { $0 }
        if flatChallenges.indices.contains(currentGlobalChallengeIndex) {
            return flatChallenges[currentGlobalChallengeIndex]
        }
        return nil
    }

    func advanceToNextChallenge() {
        if currentGlobalChallengeIndex < totalChallengesAvailable - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentGlobalChallengeIndex += 1
            }
        } else {
            print("¡TODAS LAS MISIONES Y SUB-RETOS COMPLETADOS!")
            dismiss() // O navega a una pantalla de felicitaciones
        }
    }

    var body: some View {
        if let currentChallenge = getCurrentSubChallenge() {
            SubChallengeDetailView(
                subChallenge: currentChallenge, // Pasas el SubChallenge actual
                onSubChallengeCompleted: advanceToNextChallenge
            )
            .id(currentChallenge.id) // ¡MUY IMPORTANTE para el reinicio de estado de SubChallengeDetailView!
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity))
            )
        } else {
            // Vista de "Has completado todo" o error
            VStack {
                Text("¡Eres un crack! Has completado todos los retos por ahora.")
                    .font(.title)
                Button("Volver al Inicio") {
                    dismiss() // O tu lógica para volver al HomeView
                }
            }
        }
    }
}

// Preview
struct MissionPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MissionPlayerView(initialMissions: [misionLikesSubChallenges, misionGadgetsSubChallenges])
    }
}
