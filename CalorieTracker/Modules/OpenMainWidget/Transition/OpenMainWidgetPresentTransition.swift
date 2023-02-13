//
//  OpenMainWidgetPresentTransition.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.02.2023.
//

import UIKit

class OpenMainWidgetPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to),
              let fromController = transitionContext.viewController(forKey: .from) else {
            return
        }
        let fromControllerFrame = fromController.view.frame
        toView.frame = CGRect(
            origin: fromControllerFrame.origin,
            size: .init(
                width: fromControllerFrame.width,
                height: fromControllerFrame.width * 0.561
            )
        )
        toView.layer.opacity = 0.1
        toView.layer.cornerRadius = 40
        toView.layer.maskedCorners = .topCorners
        toView.layer.masksToBounds = true
    
        container.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut) {
            toView.layer.opacity = 1
            toView.frame = fromController.view.frame
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
