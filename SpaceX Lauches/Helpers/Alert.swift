//
//  Alert.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/6/1402 AP.
//

import UIKit

protocol AlertPresentable {
    func showAlert(title: String, message: String, completion: (() -> Void)?)
}

final class AlertPresenter: AlertPresentable {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}

