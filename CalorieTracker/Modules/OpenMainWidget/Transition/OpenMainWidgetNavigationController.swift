//
//  OpenMainWidgetNavigationController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 10.02.2023.
//

import UIKit

class OpenMainWidgetNavigationController: UINavigationController {
    typealias Size = CTWidgetNodeConfiguration
    
    private let mainWidgetTopInsets: [OpenMainWidgetPresentController.State: CGFloat] = [
        .full: 42,
        .modal: 19
    ]
    
    private var viewControllerTopInset: CGFloat {
        WidgetContainerViewController.safeAreaTopInset
        + WidgetContainerViewController.suggestedTopSafeAreaOffset
        + Size(type: .compact).height
        + WidgetContainerViewController.suggestedInterItemSpacing
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OpenMainWidgetNavigationController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        OpenMainWidgetPresentController(
            presentedViewController: presented,
            presenting: presenting,
            topInset: viewControllerTopInset - (mainWidgetTopInsets[.modal] ?? 0)
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        OpenMainWidgetPresentTransition()
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        OpenMainWidgetDismissTransition()
    }
}
