//
//  WidgetDismissTransitionController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.03.2023.
//

import UIKit

class WidgetDismissTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    private let anchorView: UIView
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    init(anchorView: UIView) {
        self.anchorView = anchorView
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)  else {
            return
        }
        
        let toFrame = toView.frame
        
//        let fromViewInitialFrame = fromView.frame
//        let fromViewFinalFrame = CGRect(
//            origin: CGPoint(
//                x: fromViewInitialFrame.origin.x,
//                y: -fromViewInitialFrame.height
//            ),
//            size: fromViewInitialFrame.size
//        )
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            fromView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}

