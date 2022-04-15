//
//  ListViewController.swift
//  ZA-assignment
//
//  Created by VinBrain on 15/04/2022.
//

import UIKit

class ListViewController: UIViewController {
    
    //MARK: Properties
    weak var rightBarButton: UIBarButtonItem! {
        return UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(onLogoutClicked))
    }
    
    private lazy var viewModel = ListViewModel(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.title = "Gallery"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    @objc func onLogoutClicked() {
        viewModel.logout()
    }
    
}

//MARK: ListViewDelegate
extension ListViewController: ListViewDelegate {
    func didLogout() {
        navigationController?.popViewController(animated: true)
    }
    
}
