//
//  ListViewModel.swift
//  ZA-assignment
//
//  Created by VinBrain on 15/04/2022.
//

import UIKit

protocol ListViewDelegate: AnyObject {
    func didLogout()
}

class ListViewModel {
    
    // MARK: - Properties
    
    weak var delegate: ListViewDelegate?
    
    init(delegate: ListViewDelegate) {
        self.delegate = delegate
    }
    
    func logout() {
        AuthRepository.shared.logOut()
        delegate?.didLogout()
    }
}
