//
//  UIViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import UIKit

extension UIViewController {
    func configureBackBarButtonItem() {
        navigationController?.navigationBar.tintColor = R.color.onboardings.backTitle()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
//    func hideTabBarBlur() {
//        guard let tabBarController = tabBarController as? CTTabBarController else { return }
//        tabBarController.makeBlurTransperent()
//    }
//    
//    func restoreTabBarBlur() {
//        guard let tabBarController = tabBarController as? CTTabBarController else { return }
//        tabBarController.restoreBlur()
//    }
}
