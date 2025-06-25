import SwiftUI

struct ListaView: View {
    var body: some View {
        ZStack {
            Color.bege
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 2)
                )
                .frame(width: 370, height: 80)
                .shadow(radius: 2)
            
            HStack(spacing: 12) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Restaurante Verde")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text("Comida Vegana")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ListaView()
}
