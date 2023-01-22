//
//  UIViewController+addTapToHideKeyboardGesture.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.12.2022.
//

import UIKit

private let hideKeyboardDelegate = HideKeyboardDelegate()

private class HideKeyboardDelegate: NSObject, UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view,
            view is UIButton else {
            return true
        }
        return false
    }
}

extension UIViewController {
    @discardableResult
    func addTapToHideKeyboardGesture() -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = hideKeyboardDelegate
        view.addGestureRecognizer(tapGesture)
        return tapGesture
    }
}

extension UIViewController {
    var shouldHideTabBar: Bool {
        get {
            guard let tabBarController = tabBarController as? CTTabBarController else { return false }
            return tabBarController.isTabBarHidden
        }
        
        set {
            guard let tabBarController = tabBarController as? CTTabBarController else { return }
            _ = newValue ? tabBarController.hideTabBar() : tabBarController.showTabBar()
        }
    }
}
