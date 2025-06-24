//
//  LogoView.swift
//  Unifood
//
//  Created by Turma02-19 on 24/06/25.
//

import SwiftUI

struct LogoView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            InicioView()
        } else{
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
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        withAnimation {
                            isActive = true
                        }
                    }
            }
        }
    }
}

#Preview {
    LogoView()
}
