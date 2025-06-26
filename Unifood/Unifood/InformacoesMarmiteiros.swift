import SwiftUI

struct InformacoesMarmiteiros: View {
    @Environment(\.dismiss) var dismiss
    @State var auxRecebe = Location(
        nome: "Restaurante Universitário",
        foto: "ru_foto",
        descricao: "O Restaurante Universitário da UnB oferece refeições a preços acessíveis para a comunidade acadêmica.",
        latitude: -15.76408,
        longitude: -47.87047
    )
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Color("base"))
            
            Text(auxRecebe.nome)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            HStack(spacing: -1) {
                ForEach(0..<4) { _ in Image(systemName: "star.fill") }
                Image(systemName: "star.leadinghalf.filled")
            }
            .foregroundColor(Color("base"))
            
            Text(auxRecebe.descricao)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // LINK estilizado como botão
            NavigationLink(destination: Cardapio()) {
                Text("Exibir Cardápio")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("base"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
            
            Button("Ver avaliações") {
                print("Ir para avaliações")
            }
            .font(.headline)
            .foregroundColor(Color("base"))
        }
        .padding()
    }
}

#Preview {
    InformacoesMarmiteiros()
}
