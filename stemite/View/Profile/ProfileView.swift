//
//  ProfileView.swift
//  stemite
//
//  Created by iOS Lab on 13/05/25.
//

import SwiftUI


struct ProfileView: View {
    var user: User
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) { // Espacio entre secciones principales
                // --- Sección de Perfil ---
                VStack {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
                .padding(.top) // Añade un poco de espacio arrib
                
            }
        }
    }
}
let exampleusers = [
    User(id: UUID(), gender: "Female"),
]

#Preview {
    ProfileView(user: exampleusers.first!)
}
