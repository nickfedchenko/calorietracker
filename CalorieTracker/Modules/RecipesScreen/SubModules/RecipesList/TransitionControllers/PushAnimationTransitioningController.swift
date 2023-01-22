//
//  PushAnimationTransitioningController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 26.12.2022.
//

import UIKit

final class PushAnimationTransitioningController: NSObject, UIViewControllerAnimatedTransitioning {
 
    private var duration = 0.3
    private let fromViewController: UIViewController
    private let toViewController: UIViewController
    
    init(fromViewController: UIViewController, toViewController: UIViewController)  {
        self.fromViewController = fromViewController
        self.toViewController = toViewController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
       guard  let fromView = fromViewController.view,
              let toView = toViewController.view else {
           transitionContext.completeTransition(true)
           return
       }
        container.backgroundColor = UIColor(hex: "F3FFFE")
        fromView.frame = container.bounds
        toView.frame.size = container.bounds.size
        toView.frame.origin = CGPoint(x: 0, y: -toView.bounds.height)
        container.addSubview(fromView)
        container.addSubview(toView)
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            usingSpringWithDamping: 0.3,
//            initialSpringVelocity: 0.3
//        ) {
        //            fromView.frame.origin = CGPoint(x: 0, y: fromView.frame.height)
        //            toView.frame.origin = .zero
        //        } completion: { _ in
        //            fromView.frame.origin = .zero
        //            transitionContext.completeTransition(true)
        //        }
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
            fromView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        animator.addCompletion { position in
            if position == .end {
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.3,
                    initialSpringVelocity: 0.9
                ) {
                    toView.frame.origin = .zero
                } completion: { _ in
                    fromView.transform = .identity
                    transitionContext.completeTransition(true)
                }
            }
        }
        animator.startAnimation()
    }
    
}
