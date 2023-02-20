//
//  ModalSideTransitionDisappearing.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.02.2023.
//

import UIKit

class ModalSideTransitionDissapearing: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
    
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to),
            let toView = toViewController.view
        else {
            return
        }
        
        fromView.frame = container.bounds
        toView.frame = container.bounds
        toView.frame.origin.x -= container.bounds.width
        
        container.addSubviews(toView, fromView)
        
        UIView.animate(withDuration: 0.4) {
            fromView.frame.origin.x = container.bounds.width
            toView.frame.origin.x = .zero
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
