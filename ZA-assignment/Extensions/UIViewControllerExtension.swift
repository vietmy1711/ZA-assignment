//
//  UIViewControllerExtension.swift
//  ZA-assignment
//
//  Created by VinBrain on 15/04/2022.
//

import UIKit

extension UIViewController {
    func showErrorMessage(_ errorType: ErrorType) {
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: errorType.errorTitle,
                                                message: errorType.errorMessage,
                                                preferredStyle: .alert)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func replaceRootView(viewController: UIViewController) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = viewController

    }
}
