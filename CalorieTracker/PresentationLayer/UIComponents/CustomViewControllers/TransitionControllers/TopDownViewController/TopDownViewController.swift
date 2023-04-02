//
//  TopDownViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.12.2022.
//

import UIKit

class TopDownNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopDownNavigationController: UIViewControllerTransitioningDelegate {
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
