//
//  NavegationBar.swift
//  stemite
//
//  Created by iOS Lab on 13/05/25.
//

import SwiftUI

struct NavigationBar: View {
    @State private var selectedTab = 1
    let exampleUsers = [
        User(id: UUID(), gender: "Female"),
    ]

        
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "game.fill")
                    Text("Learning Paths")
                }
                .tag(1)
            
            ProfileView(user: exampleUsers.first!)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
                .tag(2)
        }
        .accentColor(Color.primaryGreen)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}


