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
    @State private var searchResults: [Location] = []
    @State private var selectedSearchItem: MKMapItem? = nil
    @State private var localSelecionado: Location? = nil
    @State private var selectedLocationId: Location.ID?
    @State var aux = Location(nome: "Restaurante Universitário", foto: "ru_foto", descricao: "O Restaurante Universitário da UnB oferece refeições a preços acessíveis para a comunidade acadêmica.", latitude: -15.76408, longitude: -47.87047)
    
    var locais = [
        Location(nome: "Restaurante Universitário", foto: "ru_foto", descricao: "O Restaurante Universitário da UnB oferece refeições a preços acessíveis para a comunidade acadêmica.", latitude: -15.76408, longitude: -47.87047)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Map(position: $position, selection: $selectedLocationId) {
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
                                self.zoomToLocation(CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude))
                                localSelecionado = local
                                aux = local
                                
                            }
                        }
                        .tag(local.id)
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
                                self.zoomToLocation(CLLocationCoordinate2D(latitude: aux.latitude, longitude: aux.longitude))
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
                        VStack {
                            ForEach(searchResults, id: \.id) { local in
                                VStack(alignment: .leading) {
                                    Text(aux.nome)
                                        .font(.headline)
                                    Text(aux.descricao)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.localSelecionado = aux
                                    self.zoomToLocation(CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude))
                                    self.searchResults = []
                                }
                            }
                            .listStyle(.plain)
                        }
                        .frame(maxHeight: 240)
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding()
            }
            .sheet(item: $localSelecionado) { local in
                InformacoesMarmiteiros(auxRecebe: aux)
                    .presentationDetents([.fraction(0.85), .large])
            }
        }
        .navigationTitle("Marmitas Próximas")
        .navigationBarTitleDisplayMode(.inline)
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

