//
//  LogoView.swift
//  Unifood
//
//  Created by Turma02-19 on 24/06/25.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        ZStack{
            Color.branco
                .ignoresSafeArea()
            VStack{
                HStack{
                    Image("chapeu")
                    Spacer()
                }
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                HStack{
                    Spacer()
                    Image("tigela")
                }
                
            }
        }
    }
}

#Preview {
    LogoView()
}
