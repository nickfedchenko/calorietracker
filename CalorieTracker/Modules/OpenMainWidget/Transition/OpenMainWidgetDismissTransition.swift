//
//  OpenMainWidgetDismissTransition.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 09.02.2023.
//

import UIKit

class OpenMainWidgetDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from),
              let toController = transitionContext.viewController(forKey: .to) else {
            return
        }
        let toControllerFrame = toController.view.frame
        fromView.frame = toControllerFrame
        fromView.layer.opacity = 1
        fromView.layer.cornerRadius = 40
        fromView.layer.maskedCorners = .topCorners
        fromView.layer.masksToBounds = true
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut) {
            fromView.layer.opacity = 0.1
            fromView.frame = CGRect(
                origin: toControllerFrame.origin,
                size: .init(
                    width: toControllerFrame.width,
                    height: toControllerFrame.width * 0.561
                )
            )
        } completion: { _ in
            transitionContext.completeTransition(true)
            fromView.removeFromSuperview()
        }
    }
}
