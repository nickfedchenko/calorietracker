//
//  ModalSideTransitionAppearing.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.02.2023.
//

import UIKit

class ModalSideTransitionAppearing: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard
            let fromController = transitionContext.viewController(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to),
            let fromView = fromController.view,
            let toView = toController.view
        else {
            return
        }
        
        fromView.frame = container.bounds
        toView.frame = container.bounds
        toView.frame.origin.x += container.bounds.width
        
        container.addSubviews(toView, fromView)
        
        UIView.animate(withDuration: 0.4) {
            fromView.frame.origin.x -= container.bounds.width
            toView.frame.origin = .zero
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
