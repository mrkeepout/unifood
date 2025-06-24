import SwiftUI
import MapKit // Importe o MapKit para usar o mapa

// --- Modelos de Dados ---
// Estrutura para representar um restaurante favorito
struct FavoriteRestaurant: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let iconBgColor: Color
    let rating: Double
    let reviewCount: Int
    let distance: Int
}

// Estrutura para representar uma notícia
struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

// --- Dados de Exemplo ---
// Vamos criar alguns dados de exemplo para preencher a tela
struct MockData {
    static let favoriteRestaurants = [
        FavoriteRestaurant(name: "Sabor Mexicano", iconName: "face.smiling.inverse", iconBgColor: .red, rating: 4.8, reviewCount: 47, distance: 350),
        FavoriteRestaurant(name: "Tendinha", iconName: "hamburger.fill", iconBgColor: .orange, rating: 4.7, reviewCount: 86, distance: 500),
        FavoriteRestaurant(name: "Pizza Place", iconName: "pizza.fill", iconBgColor: .yellow, rating: 4.9, reviewCount: 120, distance: 800)
    ]
    
    static let newsItems = [
        NewsItem(title: "Descubra os novos pratos da semana", imageName: "plate.fill")
    ]
}


// --- Tela Principal ---
struct TelaInicial: View {
    // Estado para controlar a posição da câmera do mapa
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -15.7633, longitude: -47.8722), // Coordenadas da UnB
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))

    // Anotações para os locais no mapa
    let mapAnnotations = [
        CLLocationCoordinate2D(latitude: -15.7645, longitude: -47.8725), // Restaurante
        CLLocationCoordinate2D(latitude: -15.7620, longitude: -47.8715)  // Frangão Burguer
    ]

    var body: some View {
        ZStack {
            // Cor de fundo. Certifique-se de ter essa cor nos seus Assets.
            Color("corDeFundo").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    RecentMealsCard()
                    
                    // A chamada agora inclui uma ação a ser executada no toque.
                    NearbyPlacesSection(cameraPosition: $cameraPosition, annotations: mapAnnotations) {
                        print("Seção do mapa foi tocada! Navegando para a tela cheia...")
                        // É aqui que você adicionaria a lógica para abrir uma nova tela.
                    }
                    
                    FavoritesSection(restaurants: MockData.favoriteRestaurants)
                    LatestNewsSection(newsItems: MockData.newsItems)
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
    }
}

// --- Componentes da Tela ---

// Card 1: Suas refeições recentes
struct RecentMealsCard: View {
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Suas refeições recentes")
                    .font(.title2).fontWeight(.bold).lineLimit(2)

                Button(action: { print("Botão 'Ver' refeições pressionado") }) {
                    Text("Ver")
                        .fontWeight(.semibold).foregroundColor(.white)
                        .padding(.vertical, 12).padding(.horizontal, 40)
                        .background(Color.orange).cornerRadius(25)
                }
            }
            .padding(.leading)

            Spacer()
            
            Image(systemName: "fork.knife")
                .resizable().scaledToFit().frame(width: 80, height: 80)
                .foregroundColor(.black).padding(.trailing, 20)
        }
        .frame(height: 160).background(Color.white).cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1.5))
    }
}

// Seção 2: Marmitas mais próximas (Mapa) - AGORA É UM BOTÃO
struct NearbyPlacesSection: View {
    @Binding var cameraPosition: MapCameraPosition
    let annotations: [CLLocationCoordinate2D]
    var action: () -> Void // Ação a ser executada quando tocado

    var body: some View {
        Button(action: action) { // Envolvemos todo o conteúdo em um Button
            VStack(alignment: .leading, spacing: 16) {
                Text("Marmitas mais próximas")
                    .font(.title).fontWeight(.bold)
                    .foregroundColor(.black) // Garante que o texto não fique azul

                Map(position: $cameraPosition) {
                    ForEach(0..<annotations.count, id: \.self) { index in
                        Marker("Restaurante", systemImage: "fork.knife.circle.fill", coordinate: annotations[index])
                            .tint(.orange)
                    }
                }
                .allowsHitTesting(false) // Impede que o mapa capture os toques
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1.5) // Borda preta para consistência
                )
            }
        }
        .buttonStyle(.plain) // Remove o estilo padrão do botão, mantendo sua aparência
    }
}

// Seção 3: Seus favoritos
struct FavoritesSection: View {
    let restaurants: [FavoriteRestaurant]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Seus favoritos").font(.title).fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(restaurants) { restaurant in
                        FavoriteCardView(restaurant: restaurant)
                    }
                }
            }
        }
    }
}

// Card de um restaurante favorito
struct FavoriteCardView: View {
    let restaurant: FavoriteRestaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: restaurant.iconName)
                .font(.title).foregroundColor(.white).padding()
                .background(restaurant.iconBgColor).clipShape(Circle())
            
            Text(restaurant.name)
                .font(.headline).foregroundColor(.black)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill").foregroundColor(.yellow)
                Text("\(restaurant.rating, specifier: "%.1f")").fontWeight(.bold)
                Text("/ \(restaurant.reviewCount) avaliações").font(.caption).foregroundColor(.gray)
            }
            Spacer()
            HStack {
                Spacer()
                Text("~ \(restaurant.distance)m").font(.caption).fontWeight(.medium).foregroundColor(.gray)
            }
        }
        .padding().frame(width: 180, height: 180).background(Color.white).cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1.5))
    }
}

// Seção 4: Últimas notícias
struct LatestNewsSection: View {
    let newsItems: [NewsItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Últimas notícias").font(.title).fontWeight(.bold)
            ForEach(newsItems) { item in NewsCardView(newsItem: item) }
        }
    }
}

// Card de uma notícia
struct NewsCardView: View {
    let newsItem: NewsItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("NOVIDADE").font(.caption).fontWeight(.bold).foregroundColor(.orange)
                Text(newsItem.title).font(.title3).fontWeight(.semibold)
            }
            Spacer()
            Image(systemName: newsItem.imageName).font(.largeTitle).foregroundColor(.orange)
        }
        .padding().frame(height: 100).background(Color.white).cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1.5))
    }
}

// --- Preview ---
#Preview {
    TelaInicial()
}
