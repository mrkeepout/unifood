//
//  MainTabView.swift
//  Unifood
//
//  Created by Turma02-19 on 26/06/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                TelaInicial()
            }
            .tabItem {
                Label("Início", systemImage: "house")
            }

            NavigationStack {
                ListaMarmiteiros()
            }
            .tabItem {
                Label("Marmitas", systemImage: "fork.knife")
            }

            NavigationStack {
                MapaMarmiteiros()
            }
            .tabItem {
                Label("Mapa", systemImage: "map")
            }

            NavigationStack {
                Perfil()
            }
            .tabItem {
                Label("Perfil", systemImage: "person.circle")
            }
        }
    }
}
