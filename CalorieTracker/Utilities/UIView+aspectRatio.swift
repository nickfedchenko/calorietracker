//
//  UIView+aspectRatio.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 30.10.2022.
//

import UIKit

extension UIView {
    func aspectRatio(_ multipliedBy: CGFloat = 1) {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width).multipliedBy(multipliedBy)
        }
    }
}
