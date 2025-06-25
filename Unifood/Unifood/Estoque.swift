//
//  Estoque.swift
//  Unifood
//
//  Created by Turma02-2 on 24/06/25.
//


import SwiftUI

struct Estoque: View {
    @State private var nomeEstabelecimento: String = ""
    @State private var itensDoMenu: [String] = []

    @Environment(\.dismiss) var dismiss

    private let menuItemsKey = "savedMenuItems"

    var body: some View {
        ZStack {
            Color.corFundo.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Adicione o seu Menu")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)

                    ForEach(itensDoMenu.indices, id: \.self) { index in
                        HStack {
                            TextField("Escreva aqui...", text: $itensDoMenu[index])
                                .font(.headline)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                .onChange(of: itensDoMenu[index]) { _ in
                                    saveMenuItems()
                                }

                            Button(action: {
                                itensDoMenu.remove(at: index)
                                if itensDoMenu.isEmpty {
                                    itensDoMenu.append("")
                                }
                                saveMenuItems()
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            }
                        }
                    }

                    Button(action: {
                        itensDoMenu.append("")
                        saveMenuItems()                     }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Adicionar Item")
                        }
                        .foregroundColor(.accentColor)
                        .font(.headline)
                    }
                    .padding(.top, 10)

                    Spacer()

                    Button(action: {
                        
                        saveMenuItems()
                        print("Itens do Menu Confirmados e Salvos: \(itensDoMenu)")
                        dismiss()
                    }) {
                        Text("Confirmar")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.corCabecalho)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .padding(.top, 30)

                }
                .padding()
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadMenuItems)        }
    }

   
    private func saveMenuItems() {
        UserDefaults.standard.set(itensDoMenu, forKey: menuItemsKey)
    }

    private func loadMenuItems() {
        if let savedItems = UserDefaults.standard.stringArray(forKey: menuItemsKey) {
            itensDoMenu = savedItems
        } else {

            if itensDoMenu.isEmpty {
                itensDoMenu.append("")
            }
        }
    }
}




#Preview {
    Estoque()
}
