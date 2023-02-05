//
//  OpenMainWidgetPresentTransition.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.02.2023.
//

import UIKit

class OpenMainWidgetPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to),
              let fromController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        toView.frame = fromController.view.frame
        toView.alpha = 0.8
        container.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut) {
            toView.alpha = 1
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
