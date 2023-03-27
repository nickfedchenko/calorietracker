//
//  WidgetNavigationController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.03.2023.
//

import UIKit

class WidgetNavigationController: UINavigationController {
    let anchorView: UIView
    init(rootViewController: UIViewController, anchorView: UIView) {
        self.anchorView = anchorView
        super.init(rootViewController: rootViewController)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WidgetNavigationController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        TopDownPresentTransition()
    }

    func animationController(
        forDismissed _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        TopDownDismissTransition()
    }
}

