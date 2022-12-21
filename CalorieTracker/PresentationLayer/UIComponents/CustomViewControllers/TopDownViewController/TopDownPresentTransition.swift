//
//  PresentTransition.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.12.2022.
//

import UIKit

class TopDownPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to),
              let fromController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        var toViewInitialFrame = fromController.view.frame
        toViewInitialFrame.origin.y = -toView.frame.size.height
        
        toView.frame = toViewInitialFrame
        container.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toView.frame = fromController.view.frame
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
