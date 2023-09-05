//
//  UIViewController.swift
//  DogCeoDemo
//
//  Created by Connor on 2023/8/16.
//

import UIKit

extension UIViewController {
    func setNavigationStyle() {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = .black
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
