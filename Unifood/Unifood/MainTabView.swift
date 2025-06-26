//
//  MainTabView.swift
//  Unifood
//
//  Created by Turma02-19 on 26/06/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        // TabView para a navegação principal do app
        TabView {
            // Tab 1: Leva para a TelaInicial
            // A TelaInicial já contém seu próprio NavigationStack
            TelaInicial()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Início")
                }

            // Tab 2: Leva para a Lista de Marmiteiros
            // Envolvemos em um NavigationStack para exibir o título da tela
            NavigationStack {
                ListaMarmiteiros()
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Marmitas")
            }

            // Tab 3: Leva para o Mapa de Marmiteiros
            // O MapaMarmiteiros já contém seu próprio NavigationStack
            MapaMarmiteiros()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Mapa")
                }

            // Tab 4: Leva para a tela de Perfil
            // Envolvemos em um NavigationStack para consistência e título
            NavigationStack {
                Perfil()
                    .navigationTitle("Seu Perfil")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Perfil")
            }
        }
        // Define a cor dos ícones e texto selecionados na TabView
        .accentColor(.orange)
    }
}

#Preview {
    MainTabView()
}
