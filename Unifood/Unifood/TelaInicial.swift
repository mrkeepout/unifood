import SwiftUI

struct TelaInicial: View {
    var body: some View {
        ZStack {
            Color("corDeFundo") // Nome da cor definida no Assets.xcassets
                .ignoresSafeArea()

            ScrollView {
                //Card 1
                VStack {
                    ZStack {
                        // Fundo do card
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                            .frame(width: 370, height: 188)

                        // Conteúdo do card
                        HStack {
                            // Texto + botão
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Suas refeições recentes")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    print("Botão Ver pressionado")
                                }) {
                                    Text("Ver")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 50)
                                        .padding(.vertical, 10)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]),
                                                           startPoint: .leading,
                                                           endPoint: .trailing)
                                        )
                                        .cornerRadius(25)
                                }
                            }
                            .padding(.leading, 10)

                            Spacer()

                            Image(systemName: "fork.knife.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 140)
                                .foregroundColor(.black)
                                .padding(.trailing, 20)
                        }
                        .frame(width: 350, height: 160)
                    }
                    .padding()
                }//card 1
                
                Text("Marmitas mais\npróximas")

                //Card 2
                VStack {
                    ZStack {
                        // Fundo do card
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                            .frame(width: 370, height: 188)

                        // Conteúdo do card
                        HStack {
                            // Texto + botão
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Marmitas mais próximas")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    print("Botão Ver pressionado")
                                }) {
                                    Text("Ver")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 50)
                                        .padding(.vertical, 10)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]),
                                                           startPoint: .leading,
                                                           endPoint: .trailing)
                                        )
                                        .cornerRadius(25)
                                }
                            }
                            .padding(.leading, 10)

                            Spacer()

                            Image(systemName: "map.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 140)
                                .foregroundColor(.black)
                                .padding(.trailing, 20)
                        }
                        .frame(width: 350, height: 160)
                    }
                    .padding()
                }//card 1
                
                
            }
        }
    }
}

#Preview {
    TelaInicial()
}
