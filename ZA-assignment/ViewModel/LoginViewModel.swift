//
//  LoginViewModel.swift
//  ZA-assignment
//
//  Created by VinBrain on 15/04/2022.
//


import UIKit

protocol LoginDelegate: AnyObject {
    func didLoginSuccess()
    func didLoginFailed(error: ErrorType)
}

class LoginViewModel {
    
    // MARK: - Properties
    
    weak var delegate: LoginDelegate?
    
    init(delegate: LoginDelegate) {
        self.delegate = delegate
    }
    
    func login() {
        if AuthRepository.shared.isLoggedIn {
            return
        }
        AuthRepository.shared.authorize { code in
            AuthRepository.shared.token(code: code) { [weak self] success, errType in
                guard let self = self else { return }
                if (success) {
                    self.delegate?.didLoginSuccess()
                } else {
                    self.delegate?.didLoginFailed(error: errType ?? .fetchingUnknown)
                }
            }
        }
    }
    
    func checkLoggedIn() {
        if AuthRepository.shared.isLoggedIn {
            self.delegate?.didLoginSuccess()
        }
    }
}
