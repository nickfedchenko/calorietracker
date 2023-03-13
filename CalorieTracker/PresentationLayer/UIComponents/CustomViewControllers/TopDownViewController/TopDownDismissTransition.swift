//
//  DismissTransition.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.12.2022.
//

import UIKit

class TopDownDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        
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
