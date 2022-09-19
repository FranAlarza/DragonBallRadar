//
//  LoginViewController.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 8/9/22.
//

import UIKit

protocol LoginViewControllerProtocol: AnyObject {
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
    var viewModel: loginViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.checkForToken(account: "franalarza@gmail.com", service: "Token")
        //CoreDataManager.shared.deleteEntity(entityName: "PersistenceHeros")
    }
    
    // MARK: - IBACTIONS
    @IBAction func didLoginTap(_ sender: Any) {
        activityIndicator.startAnimating()
        guard let user = usernameTextField.text,
              let password = passwordTextField.text else { return }
        if user.isValidEmail && !password.isEmpty {
            viewModel?.getTokenAccess(user: user, password: password)
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        
    }
}

extension LoginViewController: LoginViewControllerProtocol {
    func navigateToMapView() {
        let rootVC = MapHeroesViewController()
        rootVC.viewModel = MapHeroesViewModel(delegate: rootVC)
        let navController = UINavigationController(rootViewController: rootVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        present(navController, animated: true)
    }
}
