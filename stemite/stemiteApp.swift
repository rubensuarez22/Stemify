//
//  stemiteApp.swift
//  stemite
//
//  Created by iOS Lab on 12/05/25.
//

import SwiftUI

@main
struct stemiteApp: App { // Asegúrate que el nombre coincida con tu proyecto
    // Estado para controlar la visibilidad de la pantalla de carga
    @State private var isAppLoading: Bool = true
    
    // @AppStorage para recordar si el onboarding ya se completó
    // La clave DEBE SER ÚNICA para tu app para evitar conflictos
    @AppStorage("hasCompletedSTEMFlowOnboarding_v1") var hasCompletedOnboarding: Bool = false

    init() {
        // Aquí podrías realizar configuraciones iniciales que no dependan de la UI
        // como configurar Firebase, etc.
        // Pero la lógica de qué vista mostrar irá en el `body`.
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Esta es la vista que se mostrará DESPUÉS de la carga inicial
                // y DESPUÉS de la decisión del onboarding
                if !isAppLoading { // Solo mostrar si la carga inicial ha terminado
                    if hasCompletedOnboarding {
                        // Si el onboarding YA se completó, muestra tu vista principal
                        // que parece ser NavigationBar() en tu código.
                        // NavigationBar() probablemente contenga tu HomeView o similar.
                        NavigationBar()
                    } else {
                        // Si el onboarding NO se ha completado, muestra WelcomeView.
                        // WelcomeView se encargará de lanzar OnboardingView (tu FlowDetectorPageView).
                        // Le pasamos el @Binding para que pueda actualizar el estado.
                        WelcomeView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    }
                }

                // Superponer LaunchView si isAppLoading es true
                if isAppLoading {
                    LaunchView() // Tu pantalla de carga
                        .zIndex(1) // Asegura que esté encima de todo
                        .transition(.opacity.animation(.easeOut(duration: 0.5))) // Animación de fade out
                }
            }
            .onAppear {
                // --- Simula la carga o realiza tu carga real aquí ---
                // Este DispatchQueue es solo para simular un tiempo de carga.
                // En una app real, pondrías `isAppLoading = false` en el
                // completion handler de tu carga de datos asíncrona.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Simula 2 segundos de carga
                    withAnimation {
                        isAppLoading = false // Oculta LaunchView y permite que se muestre el contenido principal
                    }
                }
            }
        }
    }
}
