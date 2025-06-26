//
//  ViewModel.swift
//  Unifood
//
//  Created by Gabriel on 25/06/25.
//

import Foundation

class ViewModel : ObservableObject {
    @Published var restaurante : [Restaurantes] = []
    
    func fetch(){
        guard let url = URL(string: "http://172.29.61.206:1880/restaurantes" ) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
                guard let data = data, error == nil else{
                return
            }
            
            do {
                let parsed = try JSONDecoder().decode([Restaurantes].self, from: data)
                
                DispatchQueue.main.async {
                    self?.restaurante = parsed
                }
            }catch{
                print(error)
            }
        }
        task.resume()
        
    }
    
    func criarestaurante(nome: String, imagemIcone: String, totalAvaliacoes: String, distanciaMetros: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://172.29.61.206:1880/restaurantes") else {
            completion(false)
            return
        }

        let restaurante = [
            "nome": nome,
            "imagemIcone": imagemIcone,
            "totalavaliacoes": totalAvaliacoes,
            "distanciametros": distanciaMetros
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: restaurante) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
}
