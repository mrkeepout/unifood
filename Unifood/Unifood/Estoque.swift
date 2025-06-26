//
//  Estoque.swift
//  Unifood
//
//  Created by Turma02-2 on 24/06/25.
//

import SwiftUI

struct Estoque: View {
    
    @StateObject private var viewModel: EstoqueViewModel
    
    @State private var nomePrato: String = ""
    @State private var quantidade: String = ""
    @State private var valorPrato: String = ""
    @State private var descricaoPrato: String = ""
    @State private var mostrarConfirmacao = false
    
    init(restaurante: Restaurantes){
        _viewModel = StateObject(wrappedValue: EstoqueViewModel(restauranteId: restaurante.id, itensIniciais: restaurante.cardapio))
    }
    
    var body: some View {
        ZStack {
            Color.corFundo.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Adicionar Novo Prato")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)

                    
                    Text("Qual o nome do prato?")
                        .font(.headline)
                    TextField("Ex: Bife com Fritas", text: $nomePrato)
                        .textFieldStyle()

                    Text("Qual a quantidade?")
                        .font(.headline)
                    TextField("Ex: 15 unidades", text: $quantidade)
                        .textFieldStyle()
                        .keyboardType(.numberPad)

                    Text("Qual o valor desse prato? (R$)")
                        .font(.headline)
                    TextField("Ex: 29,90", text: $valorPrato)
                        .textFieldStyle()
                        .keyboardType(.decimalPad)

                    Text("Escreva uma descrição do seu prato:")
                        .font(.headline)

                    TextField("Ex: Acompanha arroz, feijão e uma pequena salada.", text: $descricaoPrato, axis: .vertical)
                        .textFieldStyle()
                    
                    Spacer()

                    
                    if mostrarConfirmacao {
                        Text("✅ Prato adicionado com sucesso!")
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .transition(.opacity.animation(.easeIn))
                    }

                    Button(action: {
                        withAnimation {
                            mostrarConfirmacao = true
                        }
                        
                        nomePrato = ""
                        quantidade = ""
                        valorPrato = ""
                        descricaoPrato = ""
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                mostrarConfirmacao = false
                            }
                        }
                        
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                    }) {
                        Text("Adicionar Prato ao Cardápio")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("Adicionar Item")
            .navigationBarTitleDisplayMode(.inline)
            
            Section(header: Text("Cardápio Atual")) {
                            if viewModel.itensCardapio.isEmpty {
                                Text("Nenhum item no cardápio ainda.").foregroundColor(.gray)
                            } else {
                                ForEach(viewModel.itensCardapio) { item in
                                    VStack(alignment: .leading) {
                                        Text(item.nome).fontWeight(.bold)
                                        Text(item.descricao).font(.caption).foregroundColor(.secondary)
                                        Text("R$ \(item.preco, specifier: "%.2f")").foregroundColor(.accentColor)
                                    }
                                }
                                .onDelete(perform: viewModel.removerItem)
                            }
                        }
        }
    }
}



struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}


extension View {
    func textFieldStyle() -> some View {
        self.modifier(CustomTextFieldStyle())
    }
}


#Preview {
    Estoque()
}
