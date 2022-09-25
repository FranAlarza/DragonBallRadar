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
    @IBOutlet weak var singUpButton: UIButton!
    
    // MARK: - Cicle of life
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSignUpButtonStyle()
    }
    // MARK: - Functions
    
    func setSignUpButtonStyle() {
        singUpButton.layer.borderWidth = 2
        singUpButton.layer.cornerRadius = 16
        singUpButton.layer.borderColor = UIColor.systemOrange.cgColor
    }
    
    // MARK: - IBActions
    @IBAction func didLoginTap(_ sender: Any) {
        let login = LoginViewController()
        login.viewModel = LoginViewModel()
        login.modalPresentationStyle = .fullScreen
        login.modalTransitionStyle = .crossDissolve
        present(login, animated: true)
    }
    
    @IBAction func didSignUpTap(_ sender: Any) {
        // TODO: If i have time implement the register view
    }
    
}
