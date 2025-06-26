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
    
    @StateObject private var viewModel = ViewModel()
    
    @State private var alergiaGluten = false
    @State private var intoleranciaLactose = false
    @State private var vegetariano = false
    @State private var vegano = false
    
    @State private var nomeEstabelecimento: String = ""
    @State private var imagensEstabelecimento: [UIImage] = []
    
    // 3. Estados para controle da UI (feedback)
    @State private var isSaving = false // Para mostrar um indicador de loading
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var action: Int? = nil
    
    // MARK: --- FUNÇÃO PARA SALVAR ---
    private func salvarRestaurante() {
        // Validação simples na UI
        guard !nomeEstabelecimento.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "O nome do estabelecimento não pode ser vazio."
            showAlert = true
            return
        }
        
        isSaving = true // Começa o processo de salvar
        
        viewModel.criarRestaurante(nome: nomeEstabelecimento, imagens: imagensEstabelecimento) { success, message in
            isSaving = false // Termina o processo
            alertMessage = message
            showAlert = true
            
            if success {
                // Opcional: Limpar o formulário ou navegar para outra tela após o sucesso.
                nomeEstabelecimento = ""
                imagensEstabelecimento.removeAll()
            }
        }
    }
    
    // MARK: Inicio das view
    
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
                                Text("Informações do Negócio")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                TextField("Digite o nome do seu negócio...", text: $nomeEstabelecimento)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                ImagePicker(selectedImages: $imagensEstabelecimento)
                                    .buttonStyle(.bordered)
                                
                                if !imagensEstabelecimento.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(imagensEstabelecimento, id: \.self) { imagem in
                                                Image(uiImage: imagem)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxHeight: 150)
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                }
                                
                                // --- BOTÃO DE SALVAR ---
                                if isSaving {
                                    ProgressView("Salvando...")
                                        .padding()
                                } else {
                                    Button(action: salvarRestaurante) {
                                        Text("Salvar Restaurante")
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(.corBotoes)
                                }
                            }
                            .padding()

                            
                            
                        }//zstack externa
                        
                        
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
