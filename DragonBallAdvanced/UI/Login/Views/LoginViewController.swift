//
//  LoginViewController.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 8/9/22.
//

import UIKit

protocol LoginViewControllerProtocol {
    func navigateToMapView()
}

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - CONSTANTS
    
    
    // MARK: - VARIABLES
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
            }
            self?.navigateToMapView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkForToken(account: "franalarza@gmail.com", service: "Token")
    }
    
    // MARK: - IBACTIONS
    @IBAction func didLoginTap(_ sender: UIButton) {
        guard let user = usernameTextField.text,
              let password = passwordTextField.text else { return }
        
        if user.isValidEmail && !password.isEmpty {
            viewModel.login(user: user, password: password)
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        
    }
}

extension LoginViewController: LoginViewControllerProtocol {
    func navigateToMapView() {
        let rootVC = MapHeroesViewController()
        let navController = UINavigationController(rootViewController: rootVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        present(navController, animated: true)
    }
}
