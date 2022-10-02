//
//  LoginViewController.swift
//  DragonBallAdvanced
//
//  Created by Fran Alarza on 7/9/22.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: -IBOutlets
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Cicle of life
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Functions
    
    
    // MARK: - IBActions
    @IBAction func didLoginTap(_ sender: Any) {
        let login = LoginViewController()
        login.viewModel = LoginViewModel()
        login.modalPresentationStyle = .fullScreen
        login.modalTransitionStyle = .crossDissolve
        present(login, animated: true)
    }
    
}
