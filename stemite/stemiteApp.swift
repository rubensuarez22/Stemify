//
//  stemiteApp.swift
//  stemite
//
//  Created by iOS Lab on 12/05/25.
//

import SwiftUI

@main
struct stemiteApp: App {
    // --- Estado para controlar la carga inicial ---
    @State private var isAppLoading: Bool = true // Empieza como true

    init() {
        
    }

    var body: some Scene {
        WindowGroup {
            ZStack { // Usa un ZStack para superponer LaunchView
                if isAppLoading {
                    LaunchView() // Muestra esta vista mientras carga
                        .zIndex(1) // Asegura que esté encima
                        .transition(.opacity) // Animación de fade out (opcional)
                } else {
                    NavigationBar() 
                }
            }
            .onAppear {
                // --- Simula la carga o realiza tu carga real aquí ---
                // Por ejemplo, esperar 2 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isAppLoading = false // Oculta LaunchView y muestra NavigationBar
                    }
                }
                // En una app real, pondrías isAppLoading = false en el completion
                // handler de tu carga de datos inicial (ej. cargar perfil de usuario,
                // obtener configuración, etc.)
            }
        }
    }
}
