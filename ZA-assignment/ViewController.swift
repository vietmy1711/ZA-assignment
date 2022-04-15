//
//  ViewController.swift
//  ZA-assignment
//
//  Created by VinBrain on 14/04/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onLoginClicked(_ sender: UIButton) {
        AuthRepository.shared.authorize { [weak self] code in
            AuthRepository.shared.token(code: code) { success in
                if (success) {
                    print("logged")
                } else {
                    print("fail")
                }
            }
        }
    }
    
}

