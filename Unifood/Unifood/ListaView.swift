//
//  ListaView.swift
//  Unifood
//
//  Created by Turma02-19 on 24/06/25.
//

import SwiftUI

struct ListaView: View {
    var body: some View {
        ZStack{
            Color.bege
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 2)
                )
                .frame(width: 300, height: 80)
                .shadow(radius: 2)
            HStack{
                
            }
        }
    }
}

#Preview {
    ListaView()
}
