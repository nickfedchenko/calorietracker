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
}
