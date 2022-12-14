//
//  TopDownViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.12.2022.
//

import UIKit

class TopDownViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopDownViewController: UIViewControllerTransitioningDelegate {
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
