import SwiftUI

// --- Tela de Detalhes do Restaurante ---
struct RestaurantDetailView: View {
    @State private var selectedFilter: String = "Marmitas"
    
    var body: some View {
        ZStack {
            // Cor de fundo. Use a mesma do seu app.
            Color(Color.corDeFundo).ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    // Barra de Filtros
                    FilterBarView(filters: DadosExemplo.filters, selectedFilter: $selectedFilter)
                    
                    // Cards de Comida
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 26) {
                            ForEach(DadosExemplo.menuItems) { item in
                                MenuItemCardView(item: item)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    }
                    
                    // Seção de Avaliações
                    ReviewsSection(reviews: DadosExemplo.reviews)

                    Spacer()
                }
                .padding(.top)
            }
        }
    }
}


// --- Componentes da Tela ---

// Barra de filtros no topo
struct FilterBarView: View {
    let filters: [String]
    @Binding var selectedFilter: String

    var body: some View {
        HStack {
            ForEach(filters, id: \.self) { filter in
                Button(action: {
                    selectedFilter = filter
                }) {
                    Text(filter)
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 6)
                        .background(selectedFilter == filter ? Color.corBotoes : Color.clear)
                        .foregroundColor(selectedFilter == filter ? .white : .primary)
                        .cornerRadius(20)
                }
            }
            Spacer()
            Button(action: { print("Filtro pressionado") }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule().fill(Color.white)
            
        )
        .padding(.horizontal)

    }
}

// Card de um item do menu
struct MenuItemCardView: View {
    let item: MenuItem

    var body: some View {
        ZStack(alignment: .top) {
            // Card de fundo
            VStack(alignment: .leading, spacing: 8) {
                Spacer(minLength: 0) // Espaço para a imagem sobrepor
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.corBotoes)
                    Text("\(item.availableCount) disponíveis")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Text(item.name).font(.title).fontWeight(.bold)
                Text(item.variations).font(.subheadline).foregroundColor(.gray)
                Text(item.description).font(.callout).padding(.vertical, 4)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text("A partir de").font(.caption).foregroundColor(.black)
                        Text("R$ \(item.price, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("a unidade").foregroundColor(.gray)
                            
                    }
                    Spacer()
                    Button(action: { print("Ver ingredientes de \(item.name)") }) {
                        Text("Veja os Ingredientes")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.corBotoes)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: .gray.opacity(0.2), radius: 10, y: 5)

            /*
            
            // Imagem sobreposta
            // Para imagens reais, use um AsyncImage
            // Aqui, usamos um SF Symbol como placeholder
            Image(systemName: item.imageName)
                 .resizable()
                 .scaledToFit()
                 .frame(width: 120, height: 120)
                 .padding(20)
                 .background(.white)
                 .clipShape(Circle())
                 .shadow(radius: 10)
                 .offset(y: -70) // Puxa a imagem para cima
                 .overlay(
                     Circle().stroke(Color.white, lineWidth: 6) // Borda para esconder a linha do card
                         .offset(y: -70)
                 )
             */
        }
        .frame(width: 280)
    }
}

// Seção de Avaliações
struct ReviewsSection: View {
    let reviews: [Review]

    var body: some View {
        VStack {
            HStack {
                Text("Avaliações")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { print("Ver todas as avaliações") }) {
                    Text("Ver todas")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.corBotoes)
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(reviews) { review in
                        ReviewCardView(review: review)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// Card de uma avaliação
struct ReviewCardView: View {
    let review: Review
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: review.userImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(review.userName).fontWeight(.bold)
                Text(review.userDepartment).font(.caption).foregroundColor(.gray)
                Text(review.reviewText)
                    .font(.footnote)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .frame(width: 350)
    }
}

// --- Preview ---
#Preview {
    RestaurantDetailView()
}
