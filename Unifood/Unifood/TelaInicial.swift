import SwiftUI
import MapKit

// MARK: - TELA INICIAL (PONTO DE PARTIDA)

struct TelaInicial: View {
    
    // Chamar a ViewModel para rodar a API
    @StateObject private var viewModel = ViewModel()
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -15.7633, longitude: -47.8722), // UnB
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))

    let mapAnnotations = [
        CLLocationCoordinate2D(latitude: -15.7645, longitude: -47.8725),
        CLLocationCoordinate2D(latitude: -15.7620, longitude: -47.8715)
    ]

    
    // Elementos componentizados
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6).ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        RecentMealsCard()
                        
                        NearbyPlacesSection(cameraPosition: $cameraPosition, annotations: mapAnnotations)
                        
                        LatestRestaurantsSection(restaurantes: viewModel.restaurantes)
                        
                        FavoritesSection(restaurants: MockData.favoriteRestaurants)
                        
                        LatestNewsSection(newsItems: MockData.newsItems)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .navigationBarHidden(true) // Opcional: esconde a barra de navegação padrão
            .onAppear{
                viewModel.fetch()
            }
        }
    }
}


// MARK: --- Componentes da Tela Inicial ---

struct RecentMealsCard: View {
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Suas refeições recentes").font(.title2).fontWeight(.bold).lineLimit(2)
                Button(action: { print("Botão 'Ver' pressionado") }) {
                    Text("Ver").fontWeight(.semibold).foregroundColor(.white)
                        .padding(.vertical, 12).padding(.horizontal, 40)
                        .background(Color.orange).cornerRadius(25)
                }
            }.padding(.leading)
            Spacer()
            Image(systemName: "fork.knife").resizable().scaledToFit().frame(width: 80, height: 80)
                .foregroundColor(.black).padding(.trailing, 20)
        }
        .frame(height: 160).background(Color.white).cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1.5))
    }
}

struct NearbyPlacesSection: View {
    @Binding var cameraPosition: MapCameraPosition
    let annotations: [CLLocationCoordinate2D]

    var body: some View {
        // 3. Em vez de um Button, usamos um NavigationLink.
        NavigationLink(destination: MapaMarmiteiros()) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Marmitas mais próximas")
                    .font(.title).fontWeight(.bold)
                    .foregroundColor(.black) // Garante que o texto permaneça preto

                Map(position: $cameraPosition) {
                    ForEach(0..<annotations.count, id: \.self) { index in
                        Marker("Restaurante", systemImage: "fork.knife.circle.fill", coordinate: annotations[index])
                            .tint(.orange)
                    }
                }
                .allowsHitTesting(false) // Impede que o mapa da tela inicial capture os toques
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1.5)
                )
            }
        }
        .buttonStyle(.plain) // Remove o estilo padrão do link para não alterar a aparência
    }
}

struct LatestRestaurantsSection: View {
    let restaurantes: [Restaurantes]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Adicionados Recentemente")
                .font(.title).fontWeight(.bold)
            
            // Se não houver restaurantes, mostra uma mensagem.
            if restaurantes.isEmpty {
                Text("Nenhum restaurante novo encontrado.")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(restaurantes) { restaurante in
                            LatestRestaurantCardView(restaurante: restaurante)
                        }
                    }
                }
            }
        }
    }
}

struct LatestRestaurantCardView: View {
    let restaurante: Restaurantes
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Usa os helpers para converter Base64 e Hex
            Image(uiImage: imageFromBase64(restaurante.imagemIcone ?? "") ?? UIImage(systemName: "photo.fill")!)
                .resizable()
                .scaledToFit()
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color(hex: restaurante.corFundoIcone ?? "#CCCCCC"))
                .clipShape(Circle())

            Text(restaurante.nome ?? "Nome Indisponível")
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(1)
            if let nota = restaurante.notaMedia, let avaliacoes = restaurante.totalAvaliacoes{
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("\(restaurante.notaMedia!, specifier: "%.1f")").fontWeight(.bold)
                    /*Text("/ \(restaurante.totalAvaliacoes) avaliações")
                     .font(.caption)
                     .foregroundColor(.gray)
                     */
                }
            } else{
                Text("Sem avaliaçoes")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                // Mostra a distância se disponível
                if let distancia = restaurante.distanciaMetros {
                    Text("~ \(distancia)m")
                        .font(.caption).fontWeight(.medium).foregroundColor(.gray)
                }
            }
        }
        .padding()
        .frame(width: 180, height: 180)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1.5))
    }
}

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

struct FavoriteCardView: View {
    let restaurant: FavoriteRestaurant
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: restaurant.iconName).font(.title).foregroundColor(.white).padding()
                .background(restaurant.iconBgColor).clipShape(Circle())
            Text(restaurant.name).font(.headline).foregroundColor(.black)
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

struct LatestNewsSection: View {
    let newsItems: [NewsItem]
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Últimas notícias").font(.title).fontWeight(.bold)
            ForEach(newsItems) { item in NewsCardView(newsItem: item) }
        }
    }
}

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
