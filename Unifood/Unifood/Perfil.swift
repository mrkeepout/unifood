//
//  Perfil.swift
//  Unifood
//
//  Created by Turma02-2 on 23/06/25.
//

import SwiftUI

struct Perfil: View {
    @State private var alergiaGluten = false
    @State private var intoleranciaLactose = false
    @State private var vegetariano = false
    @State private var vegano = false
    
    var body: some View {
        VStack {
            ZStack {
                Color.corFundo
                    .ignoresSafeArea()
                
                ScrollView{
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.corCabecalho)
                            .stroke(Color.black, lineWidth: 2)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Restrições Alimentares")
                                .font(.headline)
                            
                            Toggle("Intolerante a lactose", isOn: $intoleranciaLactose)
                            Toggle("Alergia a glúten", isOn: $alergiaGluten)
                            Toggle("Vegetariano(a)", isOn: $vegetariano)
                            Toggle("Vegano(a)", isOn: $vegano)
                            
                        }.padding()
                        
                    }.padding()
                    
                    
                    VStack(spacing: 17) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.corCabecalho)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .padding(.horizontal)
                            
                            HStack {
                                Text("Histórico de Marmiteiros")
                                    .padding()
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "book.closed.fill")
                                .padding()}
                            .padding(.horizontal)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.corCabecalho)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .padding(.horizontal)
                            
                            HStack {
                                Text("Notificações")
                                    .padding()
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "bell")
                                    .padding()
                            }
                            .padding(.horizontal)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.corCabecalho)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .padding(.horizontal)
                            
                            HStack {
                                Text("Reviews publicadas")
                                    .padding()
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "pencil.and.list.clipboard")
                                    .padding()
                            }
                            .padding(.horizontal)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.corCabecalho)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .padding(.horizontal)
                            
                            HStack {
                                Text("Dados pessoais")
                                    .padding()
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "newspaper")
                                    .padding()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 16)
                    .background(Color.corFundo)
                }
            }
        }
    }
}


#Preview {
    Perfil()
}
