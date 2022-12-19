//
//  BAMenuPresentTransition.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import UIKit

class BAMenuPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to),
              let fromController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        var toViewInitialFrame = fromController.view.frame
        toViewInitialFrame.size.height = .zero
        
        toView.frame = toViewInitialFrame
        container.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut) {
            toView.frame = fromController.view.frame
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
