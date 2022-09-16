//
//  UIStackView+.swift
//  CalorieTracker
//
//  Created by Алексей on 24.08.2022.
//

import UIKit

extension UIStackView {
    func remove(arrangedSubview: UIView) {
        removeArrangedSubview(arrangedSubview)
        arrangedSubview.removeFromSuperview()
    }
    
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            remove(arrangedSubview: $0)
        }
    }
}
