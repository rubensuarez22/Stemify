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
            LandingPage()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Home")
                }
                .tag(1)
            
            ProfileView(user: exampleUsers.first!)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
                .tag(2)
        }
        .accentColor(Color.primaryOrange)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}


