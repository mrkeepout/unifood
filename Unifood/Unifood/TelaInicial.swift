import SwiftUI
import MapKit

// MARK: - TELA INICIAL (PONTO DE PARTIDA)
// -- Tela construida usando os conceitos de componentização.

struct TelaInicial: View {
    
    // Import da ViewModel
    @StateObject private var viewModel = ViewModel()
    
    // Configuracao do mapa "Locais Proximos" mostrando a UNB como exemplo
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -15.7633, longitude: -47.8722), // Coordenada da UnB
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))

    // 2 restaurantes como exemplo
    let mapAnnotations = [
        CLLocationCoordinate2D(latitude: -15.7645, longitude: -47.8725),
        CLLocationCoordinate2D(latitude: -15.7620, longitude: -47.8715)
    ]
    
    // Componentizaçao dos cards
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6).ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        //Cartao 1 - seus locais recentes
                        RecentMealsCard()
                        
                        //Cartao 2 - ultimos locais adicionados
                        LatestRestaurantsSection(restaurantes: viewModel.restaurantes)
                        
                        //Cartao 3 - locais proximos
                        NearbyPlacesSection(cameraPosition: $cameraPosition, annotations: mapAnnotations)
                        
                        //Cartao 4 - locais favoritos
                        FavoritesSection(restaurants: MockData.favoriteRestaurants)
                        
                        //Cartao 5 - ultimas noticias
                        LatestNewsSection(newsItems: MockData.newsItems)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom)
                }
            }
            .navigationDestination(for: Restaurantes.self) { restaurante in
                                Cardapio() // Navega para o cardápio ao clicar num restaurante da API
                            }
            .navigationDestination(for: FavoriteRestaurant.self) { restaurante in
                                Cardapio() // Navega para o cardápio ao clicar num favorito
                            }
            .onAppear {
                viewModel.fetch()
            }
        }//nav stack removido
    }
}


// MARK: --- Componentes da Tela Inicial ---

struct RecentMealsCard: View {
    var body: some View {
        HStack(spacing: 8) {
            // Coluna esquerda (título + botão)
            VStack(alignment: .leading, spacing: 16) {
                Text("Seus locais\nrecentes")      // <- só texto agora
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(2)

                // Botão laranja que leva para MapaMarmiteiros
                NavigationLink(destination: ContentView()) {
                    Text("Ver")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 40)
                        .background(Color.orange)
                        .cornerRadius(25)
                }
                .buttonStyle(.plain)                 // mantém visual “puro”
            }
            .padding(.leading)

            Spacer()

            // Ícone à direita
            Image(systemName: "fork.knife.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.black)
                .padding(.trailing, 20)
        }
        .frame(height: 160)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 1.5)
        )
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
                Text("A carregar restaurantes ou nenhum encontrado...")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(restaurantes) { restaurante in
                            // O card está agora dentro de um NavigationLink
                            NavigationLink(value: restaurante) {
                                LatestRestaurantCardView(restaurante: restaurante)
                            }
                            .buttonStyle(.plain) // Remove a formatação azul do link
                        }
                    }
                }
            }
        }
        // Define o destino da navegação para qualquer objeto do tipo Restaurante
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
            
            // Mostra a nota se existir
            if let nota = restaurante.notaMedia {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("\(nota, specifier: "%.1f")").fontWeight(.bold)
                }
            } else {
                 Text("Sem avaliações")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 180, height: 180)
        .background(Color.white)
        .cornerRadius(20)
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
                Text("Locais próximos")
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

struct FavoritesSection: View {
    let restaurants: [FavoriteRestaurant]
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Seus favoritos").font(.title).fontWeight(.bold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(restaurants) { restaurant in
                        NavigationLink(value: restaurant) {
                            FavoriteCardView(restaurant: restaurant)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }//vstack
        // Define o destino da navegação para qualquer objeto do tipo Restaurante
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
