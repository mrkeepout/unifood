//
//  Perfil.swift
//  Unifood
//
//  Created by Turma02-2 on 23/06/25.
//

import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var selectedImages: [UIImage]
    @State private var selectedItems: [PhotosPickerItem] = []

    var body: some View {
        PhotosPicker(
            selection: $selectedItems,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Label("Adicionar Imagens", systemImage: "photo.on.rectangle.angled")
        }
        .onChange(of: selectedItems) { oldItems, newItems in
            Task {
                selectedImages.removeAll()
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            selectedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}


struct PerfilVendedor: View {
    @State private var alergiaGluten = false
    @State private var intoleranciaLactose = false
    @State private var vegetariano = false
    @State private var vegano = false
    
    @State private var nomeEstabelecimento: String = ""
    @State private var imagensEstabelecimento: [UIImage] = []
    
    @State private var action: Int? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Color.corFundo
                        .ignoresSafeArea()
                    
                    ScrollView {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.corCabecalho)
                                .stroke(Color.black, lineWidth: 2)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                TextField("Digite o nome do seu negócio...", text: $nomeEstabelecimento)
                                    .font(.headline)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                ImagePicker(selectedImages: $imagensEstabelecimento) // Usando ImagePicker aqui
                                    .buttonStyle(.borderedProminent)
                                
                                if !imagensEstabelecimento.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(imagensEstabelecimento, id: \.self) { imagem in
                                                Image(uiImage: imagem)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxHeight: 150)
                                                    .cornerRadius(8)
                                                    .padding(.top, 8)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding()
                        
                        VStack(spacing: 17) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.corCabecalho)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                    .frame(maxWidth: .infinity, minHeight: 80)
                                    .padding(.horizontal, 1)
                                
                                .overlay {
                                    HStack {
                                        NavigationLink(
                                            destination: Estoque(), tag: 1,
                                            selection: $action)
                                        {
                                            EmptyView()
                                        }
                                        Button(action:{
                                            action = 1})
                                        {
                                            Text("Estoque")
                                            
                                                .font(.headline)}.padding()
                                        .accentColor(.black)
                                        Spacer()
                                        Image(systemName: "book.closed.fill")
                                            .padding()
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.corCabecalho)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .padding(.horizontal)
                            
                            HStack {
                                Text("Notificações")
                                    .padding()
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "bell")
                                    .padding()
                            }
                            .padding(.horizontal)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.corCabecalho)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .padding(.horizontal)
                            
                            HStack {
                                Text("Reviews publicadas")
                                    .padding()
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "pencil.and.list.clipboard")
                                    .padding()
                            }
                            .padding(.horizontal)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.corCabecalho)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .padding(.horizontal)
                            
                            HStack {
                                Text("Dados pessoais")
                                    .padding()
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "newspaper")
                                    .padding()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 16)
                    .background(Color.corFundo)
                }
            }
        }
    }
}
#Preview {
    PerfilVendedor()
}
