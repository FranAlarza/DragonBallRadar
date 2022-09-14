//
//  NetworkManager.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 9/9/22.
//

import Foundation

enum Endpoint: String {
    case loginEndpoint = "/api/auth/login"
    case getHeroesEndpoint = "/api/heros/all"
    case geolocationEndpoint = "/api/heros/locations"
}

enum NetworkError: Error {
    case incorrectUrl
    case requestFormatError
    case dataError
    case responseError
}

struct Body: Encodable {
    var name: String?
    var id: String?
}

class NetworkManager {
    private let baseURL = "https://vapor2022.herokuapp.com"
    func login(name: String, password: String, completion: @escaping (String?, NetworkError?) -> Void) {
        
        guard let url = URL(string: "\(baseURL)\(Endpoint.loginEndpoint.rawValue)") else {
            completion(nil, .incorrectUrl)
            return
        }
        
        guard let loginStringBase64 = String(format: "%@:%@", name, password).data(using: .utf8)?.base64EncodedString() else {
            completion(nil, .requestFormatError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(loginStringBase64)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, .dataError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(nil, .responseError)
                return
            }
            
            guard error == nil else {
                return
            }
            
            let tokenResponse = String(data: data, encoding: .utf8)
            completion(tokenResponse, nil)
            
            
        }.resume()
    }
    
    func fetchDragonBallData<T: Decodable>(from endpoint: String, requestBody: Body, token: String, type: T.Type, completion: @escaping (T?, NetworkError?) -> Void) {
        
        guard let request = request(endpoint: endpoint, token: token, body: requestBody) else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else{
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(nil, .responseError)
                return
            }
            
            if let data = data {
                let result = try? JSONDecoder().decode(type.self, from: data)
                completion(result, nil)
            }
        }.resume()
    }
    
    private func request(endpoint: String, token: String, body: Body) -> URLRequest? {
       
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyRequest = body
        request.httpBody = try? JSONEncoder().encode(bodyRequest)
        return request
    }
}
