//
//  UIView+animate.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.11.2022.
//

import UIKit

extension UIView {
    enum Properties {
        case opacity(Float)
    }
    
    func animate(_ property: Properties, _ duration: TimeInterval = 0.2) {
        switch property {
        case .opacity(let value):
            UIView.animate(withDuration: duration) { [weak self] in
                self?.layer.opacity = value
            }
        }
    }
}
