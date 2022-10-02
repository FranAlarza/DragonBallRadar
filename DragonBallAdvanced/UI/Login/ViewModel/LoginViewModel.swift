//
//  LoginViewModel.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 9/9/22.
//

import Foundation

protocol LoginViewModelProtocol {
    func login(user: String, password: String)
    func checkForToken(account: String, service: String)
}

final class LoginViewModel {
    // MARK: - VARIABLES
    var networkManager: NetworkManager?
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    init(networkManager: NetworkManager? = NetworkManager(),
         onLoginSuccess: (() -> Void)? = nil,
         onLoginFailure: ((String) -> Void)? = nil) {
        self.networkManager = networkManager
        self.onLoginSuccess = onLoginSuccess
        self.onLoginFailure = onLoginFailure
    }
}

extension LoginViewModel: LoginViewModelProtocol {
    
    func login(user: String, password: String) {
        networkManager?.login(name: user, password: password) { [weak self] result in
            switch result {
            case .success(let token):
                guard let token = token?.data(using: .utf8) else { return }
                keyChainHelper.standard.save(token, service: "Token", account: "\(user)")
                UserDefaultsHelper.saveItems(item: user, key: .user)
                self?.checkForToken(account: user, service: "Token")
            case .failure(let error):
                self?.onLoginFailure?("\(error)")
            }
        }
    }
    
    func checkForToken(account: String, service: String) {
        guard let user = UserDefaultsHelper.getItems(key: .user) as? String else { return }
        guard let tokenData = keyChainHelper.standard.read(account: user, service: service),
              let token = String(data: tokenData, encoding: .utf8) else { return }
        
        if !token.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.onLoginSuccess?()
            }
        } else {
            self.onLoginFailure?("Wrong Token")
            
        }
    }
    
}
