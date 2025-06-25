import SwiftUI
import MapKit

struct Location: Hashable, Identifiable {
    let id = UUID()
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
    @State private var localSelecionado: Location? = nil
    
    @State var aux = Location(nome: "Restaurante Universitário", foto: "ru_foto", descricao: "O Restaurante Universitário da UnB oferece refeições a preços acessíveis para a comunidade acadêmica.", latitude: -15.76408, longitude: -47.87047)
    
    var locais = [
        Location(nome: "Restaurante Universitário", foto: "ru_foto", descricao: "O Restaurante Universitário da UnB oferece refeições a preços acessíveis para a comunidade acadêmica.", latitude: -15.76408, longitude: -47.87047)
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
                                    .foregroundColor(Color("base"))
                            }
                            .onTapGesture {
                                localSelecionado = local
                                aux = local
                                
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
                
                VStack(spacing: 20) {
                    Spacer()
                        TextField("Pesquisar", text: $searchText)
                            .font(.headline)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 25)
                            .shadow(radius: 10)
                            .frame(height: 0)
                            .onSubmit {
                                performSearch()
                            }
                    NavigationLink(destination: ListaMarmiteiros(auxRecebe: aux)){
                            Text("Exibir Lista")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, -7)
                        }
                        .padding()
                        .background(Color("base"))
                        .cornerRadius(10)
                        .frame(width: 400, height: 80)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    
                    if !searchResults.isEmpty {
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
                        .frame(height: min(CGFloat(searchResults.count) * 60, 240))
                        .listStyle(.plain)
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding()
            }
            .sheet(item: $localSelecionado) { local in
                InformacoesMarmiteiros(local: local)
                    .presentationDetents([.fraction(0.85), .large])
            }
        }
        .navigationTitle("Mapa de Marmiteiros")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Erro na pesquisa: \(error?.localizedDescription ?? "Desconhecido")")
                self.searchResults = []
                self.selectedSearchItem = nil
                return
            }
            
            if let firstResult = response.mapItems.first {
                self.selectedSearchItem = firstResult
                self.zoomToLocation(firstResult.placemark.coordinate)
                self.searchResults = []
                self.searchText = firstResult.name ?? ""
            } else {
                self.searchResults = []
                self.selectedSearchItem = nil
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

