//
//  UIStackView+addArrangedSubviews.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 01.09.2022.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
