//
//  WidgetPresentTransitionController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.03.2023.
//

import UIKit

class WidgetPresentTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    private let anchorView: UIView
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    init(anchorView: UIView) {
        self.anchorView = anchorView
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard
            let toView = transitionContext.view(forKey: .to),
            let toController = transitionContext.viewController(forKey: .to) as? WidgetContainerViewController,
            let fromController = transitionContext.viewController(forKey: .from) else {
            return
        }
        guard let presentationController = toController.presentationController as? WidgetPresentationController else {
            return 
        }
        print("to controller \(toController)")
//        print(toView)
        let toViewFrame = presentationController.frameOfPresentedViewInContainerView
        toView.alpha = 0
        let targetWidget = toController.getWidgetView() as? TransitionAnimationReady
//        targetWidget?.prepareForAppearing()
        let anchorViewFrame = anchorView.frame
//        print(anchorViewFrame)
        targetWidget?.frame = anchorViewFrame
        
        print("To view frame is\(toViewFrame)")
        container.addSubview(targetWidget!)
////        additionalContainer.backgroundColor = .clear
//        anchorView.clipsToBounds = true
//        let anchorViewSnapshot = anchorView.snapshotView(afterScreenUpdates: true) ?? UIView()
//        anchorView.clipsToBounds = false
//        anchorViewSnapshot.frame = anchorViewFrame
////        container.backgroundColor = .clear
//        toView.frame = anchorViewFrame
//        toView.frame = anchorViewFrame
//        let propagatedToView = toController.getWidgetView()
//        propagatedToView.frame = anchorViewFrame
//        container.addSubview(propagatedToView)
////        toView.alpha = 0
        
//        var toViewInitialFrame = fromController.view.frame
//        toViewInitialFrame.origin.y = -toView.frame.size.height
//
//        toView.frame = toViewInitialFrame
//        toView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//        container.addSubview(toView)
//        let transition = CATransition()
//        transition.duration = 1
//        transition.type = .fade
//        additionalContainer.addSubview(toView)
//        additionalContainer.layer.add(transition, forKey: nil)
        targetWidget?.prepareForAppearing()
        targetWidget?.animateAppearingFirstStage(targetFrame: toViewFrame, completion: {
            targetWidget?.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        })
//        UIView.animateKeyframes(
//            withDuration: transitionDuration(using: transitionContext),
//            delay: 0,
//            options: .layoutSubviews
//        ) {
//
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0) {
//                targetWidget?.prepareForAppearing()
//            }
//
//            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
//                targetWidget?.animateAppearingFirstStage(targetFrame: toViewFrame)
////                targetWidget?.layoutIfNeeded()
//            }

//            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
//                targetWidget?.frame = toViewFrame
//                targetWidget?.animateAppearingSecondStage()
               
//                targetWidget?.frame = toViewFrame
//                targetWidget?.layoutIfNeeded()
//            }
//        } completion: { _ in
//
//        }
        //        UIView.animate(
        //            withDuration: 3
//        ) {
//
//            targetWidget?.animateAppearing()
//        } completion: { _ in
//            targetWidget?.removeFromSuperview()
//            toView.alpha = 1
//            transitionContext.completeTransition(true)
//        }
    }
}
