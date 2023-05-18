//
//  AddFoodControllerPopAnimationController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 16.02.2023.
//

import UIKit

class AddFoodControllerPopAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard
            let toTabBarController = transitionContext.viewController(forKey: .to) as? CTTabBarController,
            let fromController = transitionContext.viewController(forKey: .from) as? AddFoodViewController,
            let toViewController = toTabBarController.viewControllers?.first as? MainScreenViewController
        else {
            return
        }

        let addButtonSnapshot = BasicButtonView(type: .add)
        let scannerSnapshot = BasicButtonView(
            type: .custom(
                .init(
                    image: .init(
                        isPressImage: nil,
                        defaultImage: R.image.scanButton.buttonNotPressed(),
                        inactiveImage: nil
                    ),
                    title: nil,
                    backgroundColorInactive: .white,
                    backgroundColorDefault: .white,
                    backgroundColorPress: .white,
                    gradientColors: nil,
                    borderColorInactive: .white,
                    borderColorDefault: .white,
                    borderColorPress: .white
                )
            )
        )
        let tabBar = toViewController.getTabBarSnapshot()
        let tabBarTargetFrame = toViewController.getTabBarTargetFrame()
        shouldAnimateRings = false
        let targetAddButtonFrame = toViewController.getCurrentAddButtonFrame()
        let targetScannerFrame = toViewController.getCurrentScannerFrame()
        let searchView = SearchView()
        let microButton = MicrophoneButton()
        searchView.frame = targetAddButtonFrame
        microButton.frame = targetScannerFrame
       
        fromController.setToStartTransitionState()
        toViewController.setToBeginningTransition()
        
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        toView.frame = container.bounds
        toView.frame.origin.x -= container.bounds.width
        fromView.frame = container.bounds
        container.addSubview(fromView)
        container.addSubview(toView)
        container.addSubview(addButtonSnapshot)
        container.addSubview(scannerSnapshot)
        toView.addSubview(tabBar)
        tabBar.frame = tabBarTargetFrame
        container.addSubviews(microButton, searchView)
        addButtonSnapshot.frame = targetAddButtonFrame
        scannerSnapshot.frame = targetScannerFrame
   
        addButtonSnapshot.alpha = 0
        scannerSnapshot.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut]) {
            searchView.alpha = 0
            addButtonSnapshot.alpha = 1
            microButton.alpha = 0
            scannerSnapshot.alpha = 1
            fromView.frame.origin.x += container.bounds.width
            toView.frame.origin.x = .zero
        } completion: { _ in
//            view.removeFromSuperview()
            tabBar.removeFromSuperview()
            searchView.removeFromSuperview()
            addButtonSnapshot.removeFromSuperview()
            microButton.removeFromSuperview()
            scannerSnapshot.removeFromSuperview()
            fromController.setToEndTransitionState()
            toViewController.setToEndedTransition()
            toTabBarController.view.setNeedsDisplay()
            shouldAnimateRings = true
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
