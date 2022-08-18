//
//  CAGradientLayer+gradientColor.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.07.2022.
//

import UIKit

extension CAGradientLayer {
    func gradientColor() -> UIColor? {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
}
