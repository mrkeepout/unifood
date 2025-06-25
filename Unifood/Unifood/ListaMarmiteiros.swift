import SwiftUI

struct FavoriteCard: View {
    let restaurant: FavoriteRestaurant

    var body: some View {
        VStack(spacing: 8) {
            HStack{
                ZStack {
                    Image(systemName: restaurant.iconName)
                        .font(.system(size: 70))
                        .foregroundColor(Color("base"))
                        
                }
                VStack{
                    Text(restaurant.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                    Spacer()
                    HStack{
                        HStack(spacing: 0){
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                            Image(systemName: "star.leadinghalf.filled")
                            
                        }
                        .foregroundColor(Color("base"))
                        Text(String(format: "%.1f", restaurant.rating))
                    }
                    
                    
                    HStack {
                        Text("(\(restaurant.reviewCount))")
                            .foregroundColor(.gray)
                        Text("•")
                            .foregroundColor(.gray)
                        Text("\(restaurant.distance)m")
                            .foregroundColor(.gray)
                    }
                    .font(.caption)
                    
                    
                }
                
            }
        }
            
        .padding()
        .frame(width: 340)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ListaMarmiteiros: View {
    @State var auxRecebe = Location(nome: "Restaurante Universitário", foto: "ru_foto", descricao: "O Restaurante Universitário da UnB oferece refeições a preços acessíveis para a comunidade acadêmica.", latitude: -15.76408, longitude: -47.87047)
    
        var body: some View {
            NavigationStack{
                VStack(alignment: .leading, spacing: 16) {
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 8) {
                            HStack{
                                ZStack {
                                    Image(systemName: "fork.knife.circle.fill")
                                        .font(.system(size: 70))
                                        .foregroundColor(Color("base"))
                                        
                                }
                                VStack{
                                    Text(auxRecebe.nome)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .padding(.top, 8)
                                    Spacer()
                                    Text(auxRecebe.descricao)
                                        .font(.caption)
                                    HStack{
                                        
                                        HStack(spacing: 0){
                                            
                                            Image(systemName: "star.fill")
                                            Image(systemName: "star.fill")
                                            Image(systemName: "star.fill")
                                            Image(systemName: "star.fill")
                                            Image(systemName: "star.leadinghalf.filled")
                                            
                                        }
                                        
                                        .foregroundColor(Color("base"))
                                    }
                                    
                                }
                                
                            }
                        }
                        .padding()
                        .frame(width: 340)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
            .navigationTitle("Mapa de Marmiteiros")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
}

#Preview {
    ListaMarmiteiros()
    
}
