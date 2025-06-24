//
//  ContentView.swift
//  Unifood
//
//  Created by Turma02-11 on 23/06/25.
//

import SwiftUI

struct InicioView: View {
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
                Text("Descubra a marmita mais\n próxima, disponibilidade,\n cárdapio e muito mais!")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundStyle(.white)
                Spacer()
                Text("Sua comida\n de forma rápida\n e fácil")
                    .foregroundStyle(.white)
                    .font(.system(size: 32, weight: .bold, design: .default))
                Spacer()
//                Button(action{
//                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
//                })
            }
        }
    }
}

#Preview {
    InicioView()
}
