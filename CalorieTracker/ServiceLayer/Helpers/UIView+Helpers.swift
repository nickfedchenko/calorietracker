//
//  UIView+Helpers.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 06.08.2022.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
