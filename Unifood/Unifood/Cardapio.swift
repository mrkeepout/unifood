import SwiftUI

// MARK: - Tela principal que outras páginas irão chamar
struct Cardapio: View {
    @State private var selectedFilter: String = "Marmitas"
    
    var body: some View {
        ZStack {
            Color(Color.corDeFundo).ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    
                    FilterBarView(filters: DadosExemplo.filters,
                                  selectedFilter: $selectedFilter)
                    
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
                    
                    ReviewsSection(reviews: DadosExemplo.reviews)
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
    }
}

// MARK: - Sub-views (podem ficar no mesmo arquivo ou em arquivos próprios)

// 1. Barra de filtros
fileprivate struct FilterBarView: View {
    let filters: [String]
    @Binding var selectedFilter: String
    
    var body: some View {
        HStack {
            ForEach(filters, id: \.self) { filter in
                Button {
                    selectedFilter = filter
                } label: {
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
            Button { print("Filtro pressionado") } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color.white))
        .padding(.horizontal)
    }
}

// 2. Card de item do menu
fileprivate struct MenuItemCardView: View {
    let item: MenuItem
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Spacer(minLength: 0)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.corBotoes)
                    Text("\(item.availableCount) disponíveis")
                        .font(.caption).fontWeight(.medium)
                }
                
                Text(item.name).font(.title).fontWeight(.bold)
                Text(item.variations).font(.subheadline).foregroundColor(.gray)
                Text(item.description).font(.callout).padding(.vertical, 4)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text("A partir de").font(.caption).foregroundColor(.black)
                        Text("R$ \(item.price, specifier: "%.2f")")
                            .font(.title2).fontWeight(.bold)
                        Text("a unidade").foregroundColor(.gray)
                    }
                    Spacer()
                    Button { print("Ver ingredientes de \(item.name)") } label: {
                        Text("Veja os Ingredientes")
                            .font(.caption).fontWeight(.bold).foregroundColor(.white)
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color.corBotoes).cornerRadius(10)
                    }
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 30, trailing: 20))
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: .gray.opacity(0.2), radius: 10, y: 5)
        }
        .frame(width: 280)
    }
}

// 3. Seção de avaliações
fileprivate struct ReviewsSection: View {
    let reviews: [Review]
    
    var body: some View {
        VStack {
            HStack {
                Text("Avaliações").font(.title2).fontWeight(.bold)
                Spacer()
                Button { print("Ver todas as avaliações") } label: {
                    Text("Ver todas")
                        .font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Color.corBotoes).cornerRadius(20)
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

// 4. Card de avaliação individual
fileprivate struct ReviewCardView: View {
    let review: Review
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: review.userImageName)
                .resizable().scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text(review.userName).fontWeight(.bold)
                Text(review.userDepartment).font(.caption).foregroundColor(.gray)
                Text(review.reviewText).font(.footnote).padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white).cornerRadius(15)
        .frame(width: 350)
    }
}

// MARK: - Preview
#Preview {
    Cardapio()
}
