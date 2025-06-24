import SwiftUI

struct InicioView: View {
    @State private var action: Int? = nil     // controla a navegação

    var body: some View {
        NavigationView {
            ZStack {
                Image("mulher")
                    .resizable()
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Image("logo")
                        Spacer()
                    }
                    .padding()
                    Text("Descubra a marmita mais\n próxima, disponibilidade,\n cardápio e muito mais!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top)

                    Spacer()
                    Text("Sua comida\n de forma rápida\n e fácil")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Spacer()
                    NavigationLink(
                        destination: ContentView(),
                        tag: 1,
                        selection: $action
                    ) { EmptyView() }
                    Button(action: {
                        action = 1
                    }) {
                        Text("Começar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 40)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    InicioView()
}
