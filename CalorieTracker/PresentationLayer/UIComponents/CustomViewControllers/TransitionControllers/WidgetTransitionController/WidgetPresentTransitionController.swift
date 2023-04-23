//
//  WidgetPresentTransitionController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.03.2023.
//

import UIKit

class WidgetPresentTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    private let anchorView: UIView
    private let widgetType: WidgetContainerViewController.WidgetType
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    init(anchorView: UIView, widgetType: WidgetContainerViewController.WidgetType) {
        self.widgetType = widgetType
        self.anchorView = anchorView
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch widgetType {
        case .water:
            showWaterWidget(with: transitionContext)
        case .calendar:
            showCalendarWidget(with: transitionContext)
        case .weight:
            showWeightWidget(with: transitionContext)
        case .steps:
            showStepsWidget(with: transitionContext)
        default:
            showWaterWidget(with: transitionContext)
        }
    }
    
    func showWaterWidget(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let toController = transitionContext.viewController(forKey: .to) as? WidgetContainerViewController  else {
            return
        }
        guard let presentationController = toController.presentationController as? WidgetPresentationController else {
            return
        }
        let container = transitionContext.containerView
        let toViewFrame = presentationController.frameOfPresentedViewInContainerView
        toView.alpha = 0
        let targetWidget = toController.getWidgetView() as? TransitionAnimationReady
        let anchorViewFrame = anchorView.frame
        targetWidget?.frame = anchorViewFrame
        container.addSubview(targetWidget!)
        targetWidget?.prepareForAppearing(with: nil)
        targetWidget?.animateAppearingFirstStage(targetFrame: toViewFrame) {
            targetWidget?.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        }
    }
    
    func showCalendarWidget(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let toController = transitionContext.viewController(forKey: .to) as? WidgetContainerViewController  else {
            return
        }
        guard let presentationController = toController.presentationController as? WidgetPresentationController else {
            return
        }
        let container = transitionContext.containerView
        let toViewFrame = presentationController.frameOfPresentedViewInContainerView
        toView.alpha = 0
        let targetWidget = toController.getWidgetView() as? TransitionAnimationReady
        let anchorViewFrame = anchorView.frame
        container.addSubview(targetWidget!)
        targetWidget?.frame = anchorViewFrame
        anchorView.clipsToBounds = true
        let anchorSnapshot = anchorView.snapshotView(afterScreenUpdates: true)
        anchorView.clipsToBounds = false
        targetWidget?.prepareForAppearing(with: anchorSnapshot)
        targetWidget?.animateAppearingFirstStage(targetFrame: toViewFrame) {
            targetWidget?.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        }
    }
    
    func showWeightWidget(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let toController = transitionContext.viewController(forKey: .to) as? WidgetContainerViewController  else {
            return
        }
        guard let presentationController = toController.presentationController as? WidgetPresentationController else {
            return
        }
        let container = transitionContext.containerView
        let toViewFrame = presentationController.frameOfPresentedViewInContainerView
        toView.alpha = 0
        let targetWidget = toController.getWidgetView() as? TransitionAnimationReady
        let anchorViewFrame = anchorView.frame
        container.addSubview(targetWidget!)
        targetWidget?.frame = anchorViewFrame
        targetWidget?.setToForceRedraw()
        anchorView.clipsToBounds = true
        let anchorSnapshot = anchorView.snapshotView(afterScreenUpdates: true)
        anchorView.clipsToBounds = false
        targetWidget?.prepareForAppearing(with: anchorSnapshot)
        targetWidget?.animateAppearingFirstStage(targetFrame: toViewFrame) {
            targetWidget?.removeFromSuperview()
            toView.alpha = 1
            transitionContext.completeTransition(true)
        }
    }
    
    func showStepsWidget(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let toController = transitionContext.viewController(forKey: .to) as? WidgetContainerViewController  else {
            return
        }
        guard let presentationController = toController.presentationController as? WidgetPresentationController else {
            return
        }
        let container = transitionContext.containerView
        let toViewFrame = presentationController.frameOfPresentedViewInContainerView
        toView.alpha = 0
        anchorView.alpha = 0
        let anchorViewFrame = anchorView.frame
        let date = UDM.currentlyWorkingDay.date ?? Date()
        let goal = StepsWidgetService.shared.getDailyStepsGoal()
        let now = StepsWidgetService.shared.getStepsForDate(date)
        let progress = Double(now) / Double(goal ?? 1)
        
        let animatableView = StepsWidgetAnimatableContainer(
            initialState: .compactToFull(compactFrame: anchorViewFrame, steps: Int(now), progress: progress)
        )
        animatableView.frame = container.bounds
        container.addSubview(animatableView)
        let toViewMock = StepsFullWidgetView(frame: toViewFrame)
        toViewMock.alpha = 0
        container.addSubview(toViewMock)
        toViewMock.setNeedsLayout()
        toViewMock.layoutIfNeeded()
        animatableView.startTransitionAnimationAppearing(
            targetView: toViewMock,
            targetFrame: toViewFrame
        ) { [weak self] in
            self?.anchorView.alpha = 1
            UIView.animate(withDuration: 0.3) {
                animatableView.alpha = 1
                toView.alpha = 1
            } completion: { _ in
                animatableView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}
