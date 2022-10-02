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
    case requestError
    case dataError
    case responseError
    case geolocationsError
    case heroesError
}

struct Body: Encodable {
    var name: String?
    var id: String?
}

class NetworkManager {
    private let baseURL = "https://dragonball.keepcoding.education"
    
    var session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func login(name: String, password: String, completion: @escaping (Result<String?, NetworkError>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)\(Endpoint.loginEndpoint.rawValue)") else {
            completion(.failure(.incorrectUrl))
            return
        }
        
        guard let loginStringBase64 = String(format: "%@:%@", name, password).data(using: .utf8)?.base64EncodedString() else {
            completion(.failure(.requestFormatError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(loginStringBase64)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(.failure(.responseError))
                return
            }
            
            guard error == nil else {
                completion(.failure(.requestError))
                return
            }
            
            let tokenResponse = String(data: data, encoding: .utf8)
            completion(.success(tokenResponse))
            
            
        }.resume()
    }
    
    func fetchDragonBallData<T: Decodable>(from endpoint: String, requestBody: Body?, token: String, type: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        
        guard let request = request(endpoint: endpoint, token: token, body: requestBody) else { return }
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else{
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data else { return }
            
            if let result = try? JSONDecoder().decode(type.self, from: data) {
                completion(.success(result))
            } else {
                completion(.failure(.dataError))
            }
        }.resume()
    }
    
    private func request<R: Encodable>(endpoint: String, token: String, body: R) -> URLRequest? {
       
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONEncoder().encode(body)
        return request
    }
}
