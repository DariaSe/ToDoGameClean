//
//  Common Protocols.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 14.03.2022.
//

import UIKit

protocol DeletionAlertDisplayLogic: UIViewController {
    func displayDeletionAlert(title: String, message: String?, onDelete: @escaping () -> ())
}

protocol ErrorDisplayLogic: UIViewController {
    func displayError(_ errorText: String)
}

extension UIViewController: DeletionAlertDisplayLogic {
    func displayDeletionAlert(title: String, message: String?, onDelete: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.delete, style: .destructive, handler: { _ in
            onDelete()
        }))
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController: ErrorDisplayLogic {
    func displayError(_ errorText: String) {
        let errorView = ErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(errorView)
        errorView.alpha = 0.0
        self.view.center(subview: errorView)
        errorView.setDimensions(width: 300, height: 150)
        errorView.setText(errorText)
        UIView.animate(withDuration: 0.2) {
            errorView.alpha = 0.8
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 2.0, options: [], animations: {
                errorView.alpha = 0.0
            }, completion: nil)
        }
    }
}
