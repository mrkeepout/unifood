import SwiftUI
import MapKit

struct Location: Hashable {
    let nome: String
    let foto: String
    let descricao: String
    let latitude: Double
    let longitude: Double
}

struct MapaMarmiteiros: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -15.76579, longitude: -47.87212),
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )
    )
    
    @State private var searchText: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedSearchItem: MKMapItem? = nil
    
    var locais = [
        Location(nome: "Cristo Redentor", foto: "https://s4.static.brasilescola.uol.com.br/be/2024/05/cristo-redentor.jpg", descricao: "Localizado no topo do Morro do Corcovado, no Rio de Janeiro, o Cristo Redentor é uma icônica estátua de Jesus Cristo com os braços abertos, simbolizando a paz e a acolhida.", latitude: -22.951916, longitude: -43.210466)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Map(position: $position) {
                    ForEach(locais, id: \.self) { local in
                        Annotation(
                            local.nome,
                            coordinate: CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude)
                        ) {
                            ZStack {
                                Circle()
                                    .fill(Color("cima", bundle: nil))
                                    .frame(width: 30, height: 30)
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    if let selectedItem = selectedSearchItem {
                        Annotation(
                            selectedItem.name ?? "Local Pesquisado",
                            coordinate: selectedItem.placemark.coordinate
                        ) {}
                    }
                }
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    TextField("Pesquisar", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .shadow(radius: 5)
                        .onSubmit {
                            performSearch()
                        }
                    Button("Exibir Lista"){
                        
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    if !searchResults.isEmpty && searchText != "" {
                        List(searchResults, id: \.self) { item in
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Local Desconhecido")
                                if let address = item.placemark.title {
                                    Text(address)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .onTapGesture {
                                selectedSearchItem = item
                                zoomToLocation(item.placemark.coordinate)
                                searchResults = []
                                searchText = item.name ?? ""
                            }
                        }
                        .frame(height: min(CGFloat(searchResults.count) * 50, 200))
                        .listStyle(.plain)
                        .padding(.horizontal)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                    }
                }
                .padding(.top, 10)
            }
        }
    }
    
    func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Erro na pesquisa: \(error?.localizedDescription ?? "Desconhecido")")
                searchResults = []
                selectedSearchItem = nil
                return
            }
            searchResults = response.mapItems
            if let firstResult = response.mapItems.first {
                selectedSearchItem = firstResult
                zoomToLocation(firstResult.placemark.coordinate)
                searchResults = []
                searchText = firstResult.name ?? ""
            } else {
                selectedSearchItem = nil
            }
        }
    }
    
    func zoomToLocation(_ coordinate: CLLocationCoordinate2D) {
        withAnimation(.easeInOut(duration: 1.0)) {
            position = .region(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
    }
}

#Preview {
    MapaMarmiteiros()
}
