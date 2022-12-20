//
//  BAMenuPresentTransition.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import UIKit

class BAMenuPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let frame: CGRect
    
    init(_ frame: CGRect) {
        self.frame = frame
    }
    
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
