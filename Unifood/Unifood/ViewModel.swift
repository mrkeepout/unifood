//
//  ViewModel.swift
//  Unifood
//
//  Created by Turma02-2 on 25/06/25.
//

import Foundation
import SwiftUI // Importar SwiftUI para acessar UIImage

// MARK: Chamada de API
class ViewModel : ObservableObject {
    @Published var restaurantes : [Restaurantes] = []
    
    // URL da sua API. Certifique-se de que esteja correta.
    private let apiURL = "http://localhost:1880/restaurantes"
    
    // Função para buscar a lista de restaurantes (já existente)
    func fetch() {
        guard let url = URL(string: apiURL) else {
            print("URL inválida para fetch.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Erro no fetch: \(error?.localizedDescription ?? "Erro desconhecido")")
                return
            }
            
            do {
                let parsed = try JSONDecoder().decode([Restaurantes].self, from: data)
                
                //Filtro da lista
                let validRestaurantes = parsed.filter { $0.nome != nil && !$0.nome!.isEmpty}
                
                DispatchQueue.main.async {
                    self?.restaurantes = validRestaurantes
                }
            } catch {
                print("Erro ao decodificar JSON: \(error)")
            }
        }
        task.resume()
    }
    
    // --- FUNÇÃO ATUALIZADA PARA CRIAR RESTAURANTE ---
    func criarRestaurante(nome: String, imagens: [UIImage], completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(false, "URL da API é inválida.")
            return
        }

        // 1. Validar que pelo menos uma imagem foi selecionada.
        // A API espera uma imagem, vamos pegar a primeira da lista.
        guard let primeiraImagem = imagens.first else {
            completion(false, "Por favor, selecione uma imagem para o restaurante.")
            return
        }

        // 2. Converter a UIImage para Base64 String
        // Usamos compressão para reduzir o tamanho dos dados.
        guard let imageData = primeiraImagem.jpegData(compressionQuality: 0.5) else {
            completion(false, "Não foi possível converter a imagem.")
            return
        }
        let base64ImageString = imageData.base64EncodedString()

        // 3. Criar o payload usando o Model `NovoRestaurantePayload`
        // Usamos uma cor padrão. Você pode adicionar um seletor de cor na UI depois.
        let payload = NovoRestaurantePayload(
            nome: nome,
            imagemIcone: "data:image/jpeg;base64,\(base64ImageString)", // Prefixo para o browser/API entender o formato
            corFundoIcone: "#FF5733" // Cor laranja como padrão
        )

        // 4. Codificar o payload para JSON usando JSONEncoder (mais seguro)
        guard let jsonData = try? JSONEncoder().encode(payload) else {
            completion(false, "Erro ao codificar os dados para JSON.")
            return
        }

        // 5. Configurar a requisição POST
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // 6. Enviar a requisição
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    // Sucesso! (200 OK ou 201 Created)
                    completion(true, "Restaurante criado com sucesso!")
                } else {
                    // Falha
                    let errorMessage = "Erro ao criar restaurante. Status: \( (response as? HTTPURLResponse)?.statusCode ?? 0). Detalhe: \(error?.localizedDescription ?? "N/A")"
                    print(errorMessage)
                    completion(false, "Ocorreu um erro. Tente novamente.")
                }
            }
        }.resume()
    }
}


class EstoqueViewModel: ObservableObject {
    @Published var itensCardapio: [MenuItem] = []
    @Published var isLoading = false
    @Published var showSuccessMessage = false
    
    // O ID do restaurante sendo editado.
    private var restauranteId: String
    
    init(restauranteId: String, itensIniciais: [MenuItem]?) {
        self.restauranteId = restauranteId
        self.itensCardapio = itensIniciais ?? []
    }
    
    func adicionarItem(nome: String, descricao: String, preco: Double, quantidade: Int) {
        // Cria o novo item usando os parâmetros corretos da struct 'MenuItem'
        let novoItem = MenuItem(
            id: UUID(), // O 'id' é um UUID, não uma String
            name: nome,
            variations: "", // Passando um valor padrão. Você pode adicionar um campo para isso na UI depois.
            description: descricao, // O nome do parâmetro é 'description'
            price: preco,
            availableCount: quantidade, // O nome do parâmetro é 'availableCount'
            imageName: "fork.knife.circle" // Usando um ícone padrão como placeholder
        )
        itensCardapio.append(novoItem)
    }
    
    func removerItem(at offsets: IndexSet) {
        itensCardapio.remove(atOffsets: offsets)
    }
    
    func salvarCardapio() {
        isLoading = true
        
        // --- MUDANÇA PRINCIPAL AQUI ---
        
        // 1. Criar a URL para o endpoint específico do cardápio
        // SUBSTITUA "SEU_IP_AQUI" PELO IP DA MÁQUINA ONDE O NODE-RED ESTÁ RODANDO
        guard let url = URL(string: "http://SEU_IP_AQUI:1880/restaurantes/\(self.restauranteId)/cardapio") else {
            print("URL inválida para o endpoint de cardápio.")
            self.isLoading = false
            return
        }
        
        // 2. Codificar o array `itensCardapio` DIRETAMENTE para JSON.
        // Não precisamos mais envolvê-lo em outra struct.
        guard let jsonData = try? JSONEncoder().encode(self.itensCardapio) else {
            print("Erro ao codificar o cardápio para JSON.")
            self.isLoading = false
            return
        }
        
        // 3. Criar a requisição com o método PUT (para substituir o cardápio existente)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // 4. Enviar a requisição (o restante do código é o mesmo)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.showSuccessMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.showSuccessMessage = false
                    }
                } else {
                    print("Erro na API ao salvar cardápio: \(error?.localizedDescription ?? "Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")")
                }
            }
        }.resume()
    }
}
