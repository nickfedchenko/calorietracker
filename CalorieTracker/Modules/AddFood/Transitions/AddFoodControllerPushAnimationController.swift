//
//  AddFoodControllerAnimationAppearing.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 15.02.2023.
//

import UIKit

class AddFoodControllerPushAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard
            let toViewController = transitionContext.viewController(forKey: .to) as? AddFoodViewController,
            let fromTabBarController = transitionContext.viewController(forKey: .from) as? CTTabBarController,
            let fromController = fromTabBarController.viewControllers?.first as? MainScreenViewController
        else {
            return
        }
        print("Successfully got controllers")
        // Берем снапшоты так как это ASDK ноды, что-то адекватное родить сильно сложно тут. Отдельно рендерим снапшот
        // таббара так как он лежит в отдельной от fromView контроллере.
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
        let tabBar = fromController.getTabBarSnapshot()
        let tabBarTargetFrame = fromController.getTabBarTargetFrame()
      
        let targetAddButtonFrame = fromController.getCurrentAddButtonFrame()
        let targetScannerFrame = fromController.getCurrentScannerFrame()
        let searchView = SearchView()
        let microButton = {
            let button = UIButton()
            button.setImage(R.image.addFood.menu.micro(), for: .normal)
            button.backgroundColor = R.color.addFood.menu.isNotSelectedBorder()
            button.imageView?.tintColor = R.color.addFood.menu.isSelectedBorder()
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 1
            button.layer.borderColor = R.color.addFood.menu.isSelectedBorder()?.cgColor
            return button
        }()
        searchView.frame = targetAddButtonFrame
        microButton.frame = targetScannerFrame
       
        fromController.setToBeginningTransition()
        toViewController.setToStartTransitionState()
        
        guard  let fromView = transitionContext.view(forKey: .from),
               let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        container.addSubview(fromView)
        container.addSubview(toView)
        toView.frame = container.bounds
        toView.frame.origin.x += container.bounds.width
        fromView.frame = container.bounds
        container.addSubview(addButtonSnapshot)
        container.addSubview(scannerSnapshot)
        fromView.addSubview(tabBar)
        tabBar.frame = tabBarTargetFrame
        container.addSubviews(microButton, searchView)
        addButtonSnapshot.frame = targetAddButtonFrame
        scannerSnapshot.frame = targetScannerFrame
   
        microButton.alpha = 0
        searchView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut]) {
            searchView.alpha = 1
            addButtonSnapshot.alpha = 0
            microButton.alpha = 1
            scannerSnapshot.alpha = 0
            fromView.frame.origin.x -= container.bounds.width
            toView.frame.origin.x = .zero
        } completion: { _ in
//            view.removeFromSuperview()
            tabBar.removeFromSuperview()
            searchView.removeFromSuperview()
            addButtonSnapshot.removeFromSuperview()
            microButton.removeFromSuperview()
            scannerSnapshot.removeFromSuperview()
            fromController.setToEndedTransition()
            toViewController.setToEndTransitionState()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
