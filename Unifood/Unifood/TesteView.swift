//
//  ContentView.swift
//  Unifood
//
//  Created by Turma02-11 on 23/06/25.
//

import SwiftUI

struct TesteView: View {
    var body: some View {
        ZStack{
            Image("mulher")
                .resizable()
                .ignoresSafeArea()
            VStack{
                HStack{
                    Image("logo")
                    Spacer()
                }
                Text("Descubra a marmita mais próxima, disponibilidade, cárdapio e muito mais!")
                    .foregroundStyle(.white)
                Spacer()
                Text("Sua comida de forma rápida e fácil")
                    .foregroundStyle(.white)
                Spacer()
            }
        }
    }
}

#Preview {
    TesteView()
}
