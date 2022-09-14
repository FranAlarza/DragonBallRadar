//
//  LoginViewModel.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 9/9/22.
//

import Foundation

protocol loginViewModelProtocol {
    func onViewsLoaded()
    func getTokenAccess(user: String, password: String)
    func checkForToken(account: String, service: String)
}

final class LoginViewModel {
    // MARK: - CONSTANTS
    let networkManager = NetworkManager()
    
    // MARK: - VARIABLES
    weak var delegate: LoginViewControllerProtocol?
    
    init(delegate: LoginViewControllerProtocol) {
        self.delegate = delegate
    }
}

extension LoginViewModel: loginViewModelProtocol {
    func onViewsLoaded() {
        //
    }
    
    func getTokenAccess(user: String, password: String) {
        networkManager.login(name: user, password: password) { token, error in
            guard let dataToken = token?.data(using: .utf8) else { return }
            keyChainHelper.standard.save(dataToken, service: "Token", account: "\(user)")
        }
    }
    
    func checkForToken(account: String, service: String) {
        guard let tokenData = keyChainHelper.standard.read(account: account, service: service),
              let token = String(data: tokenData, encoding: .utf8) else { return }
        
        if !token.isEmpty {
            delegate?.navigateToMapView()
        } else {
            return
        }
    }
    
}
