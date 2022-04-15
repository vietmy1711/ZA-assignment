//
//  ViewController.swift
//  ZA-assignment
//
//  Created by VinBrain on 14/04/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    private lazy var viewModel = LoginViewModel(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.checkLoggedIn()
    }

    @IBAction func onLoginClicked(_ sender: UIButton) {
        viewModel.login()
    }
    
}

extension LoginViewController: LoginDelegate {
    func didLoginSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(ListViewController(), animated: true)
        }
    }
    
    func didLoginFailed(error: ErrorType) {
        showErrorMessage(error)
    }
    
    
}

