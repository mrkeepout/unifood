import Foundation
import SwiftUI

// MARK: - Modelo para a tela inicial - vai  ser excluida

struct FavoriteRestaurant: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let iconBgColor: Color
    let rating: Double
    let reviewCount: Int
    let distance: Int
}

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct MockData {
    static let favoriteRestaurants = [
        FavoriteRestaurant(name: "Sabor Mexicano",
                           iconName: "face.smiling.inverse",
                           iconBgColor: .red,
                           rating: 4.8,
                           reviewCount: 47,
                           distance: 350),
        FavoriteRestaurant(name: "Tendinha",
                           iconName: "hamburger.fill",
                           iconBgColor: .orange,
                           rating: 4.7,
                           reviewCount: 86,
                           distance: 500)
    ]
    
    static let newsItems = [
        NewsItem(title: "Descubra os novos pratos da semana", imageName: "plate.fill")
    ]
}


// MARK: - Modelo para a lista de restaurantes (Endpoint /restaurantes)

/// Representa um restaurante na lista principal. É uma versão resumida dos dados.
struct Restaurantes: Codable, Identifiable {
    var id: String { _id }
    let _id: String
    let nome: String?
    let imagemIcone: String?
    let corFundoIcone: String?
    let notaMedia: Double?
    let totalAvaliacoes: Int?
    let distanciaMetros: Int?

    // Mapeia os nomes do JSON (snake_case) para os nomes em Swift (camelCase)
    enum CodingKeys: String, CodingKey {
        case _id
        case nome
        case imagemIcone = "imagem_icone"
        case corFundoIcone = "cor_fundo_icone"
        case notaMedia = "nota_media"
        case totalAvaliacoes = "total_avaliacoes"
        case distanciaMetros = "distancia_metros"
    }
}


// MARK: - Modelo para os detalhes de um restaurante (Endpoint /restaurantes/{id})

/// Representa todos os detalhes de um restaurante, incluindo cardápio e avaliações.
struct RestauranteDetalhado: Codable, Identifiable {
    let id: String
    let nome: String
    let cardapio: [MenuItem]
    let avaliacoes: [Review]
    
    // Você pode adicionar outros campos que venham neste endpoint aqui.
}

// MARK: - Modelos de teste de tela

// --- Modelos de Dados ---

// Estrutura para um item do menu
struct MenuItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let variations: String
    let description: String
    let price: Double
    let availableCount: Int
    let imageName: String // Usaremos SF Symbols como placeholders
}
 
// Estrutura para uma avaliação
struct Review: Codable, Identifiable {
    let id = UUID()
    let userName: String
    let userDepartment: String
    let reviewText: String
    let userImageName: String // Placeholder para a foto do usuário
}

// --- Dados de Exemplo ---
struct DadosExemplo {
    static let menuItems = [
        MenuItem(name: "Tacos", variations: "Carne/Frango/Queijo", description: "Um sabor tão espetacular que você irá gritar Arriba!", price: 14.00, availableCount: 8, imageName: "taco"),
        MenuItem(name: "Pozole", variations: "Branco/Verde", description: "A Hueso! Delícia com tudo que há de bom e mais um pouco.", price: 15.00, availableCount: 2, imageName: "bowl")
    ]
    
    static let reviews = [
        Review(userName: "DisneiLandia S.", userDepartment: "Arquivologia", reviewText: "Um dos melhores marmiteiros da UnB, podem confiar!", userImageName: "person.crop.circle.fill.badge.checkmark"),
        Review(userName: "Free Willie", userDepartment: "Física", reviewText: "Um do marmiteiros que podem.", userImageName: "person.crop.circle.fill")
    ]

    static let filters = ["Todos", "Marmitas", "Sobremesas"]
}

/*// MARK: - Modelos Aninhados

/// Representa um item do cardápio de um restaurante.
struct MenuItem: Codable, Identifiable {
    // Usaremos idItem como a propriedade para 'Identifiable'
    var id: String { idItem }
    
    let idItem: String
    let nome: String
    let imagemPrato: String
    let variacoes: String
    let descricao: String
    let preco: Double
    let quantidadeDisponivel: Int

    enum CodingKeys: String, CodingKey {
        case idItem = "id_item"
        case nome
        case imagemPrato = "imagem_prato"
        case variacoes, descricao, preco
        case quantidadeDisponivel = "quantidade_disponivel"
    }
}

/// Representa uma avaliação feita por um usuário.
struct Review: Codable, Identifiable {
    // Usaremos idAvaliacao como a propriedade para 'Identifiable'
    var id: String { idAvaliacao }
    
    let idAvaliacao: String
    let nomeUsuario: String
    let departamentoUsuario: String
    let textoAvaliacao: String
    let imagemUsuario: String

    enum CodingKeys: String, CodingKey {
        case idAvaliacao = "id_avaliacao"
        case nomeUsuario = "nome_usuario"
        case departamentoUsuario = "departamento_usuario"
        case textoAvaliacao = "texto_avaliacao"
        case imagemUsuario = "imagem_usuario"
    }
}
*/
// MARK: - Modelos para Criação de Dados (POST)

/// Estrutura usada para enviar dados para criar um novo restaurante.
struct NovoRestaurantePayload: Codable {
    let nome: String
    let imagemIcone: String
    let corFundoIcone: String
    
    enum CodingKeys: String, CodingKey {
        case nome
        case imagemIcone = "imagem_icone"
        case corFundoIcone = "cor_fundo_icone"
    }
}

/// Estrutura usada para enviar dados para adicionar um novo item ao cardápio.
struct NovoMenuItemPayload: Codable {
    let nome: String
    let imagemPrato: String
    let variacoes: String
    let descricao: String
    let preco: Double
    let quantidadeDisponivel: Int

    enum CodingKeys: String, CodingKey {
        case nome
        case imagemPrato = "imagem_prato"
        case variacoes, descricao, preco
        case quantidadeDisponivel = "quantidade_disponivel"
    }
}


// MARK: Helpers

/// Converte uma string Base64 (com ou sem prefixo "data:image...") para UIImage.
func imageFromBase64(_ base64String: String) -> UIImage? {
    // Remove o prefixo "data:image/jpeg;base64," se existir
    let cleanBase64 = base64String.components(separatedBy: ",").last ?? base64String
    guard let data = Data(base64Encoded: cleanBase64, options: .ignoreUnknownCharacters) else {
        return nil
    }
    return UIImage(data: data)
}

/// Permite criar uma cor a partir de um código hexadecimal (ex: "#FF5733").
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // Cor padrão em caso de erro
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
