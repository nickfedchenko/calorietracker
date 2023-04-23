//
//  WidgetDismissTransitionController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 22.03.2023.
//

import UIKit

class WidgetDismissTransitionController: NSObject, UIViewControllerAnimatedTransitioning {
    private let anchorView: UIView
    private let widgetType: WidgetContainerViewController.WidgetType
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    init(anchorView: UIView, widgetType: WidgetContainerViewController.WidgetType) {
        self.anchorView = anchorView
        self.widgetType = widgetType
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch widgetType {
        case .water:
            dismissWaterWidget(with: transitionContext)
        case .calendar:
            dismissCalendarWidget(with: transitionContext)
        case .weight:
            dismissWeightWidget(with: transitionContext)
        case .steps:
            dismissStepsWidget(with: transitionContext)
        default:
            dismissWaterWidget(with: transitionContext)
        }
    }
    
    func dismissWaterWidget(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to),
            let fromController = transitionContext
                .viewController(forKey: .from) as? WidgetContainerViewController else {
            return
        }
        guard let presentationController = fromController.presentationController as? WidgetPresentationController else {
            return
        }
        let fromViewFrame = presentationController.frameOfPresentedViewInContainerView
        anchorView.alpha = 0
        guard let fromWidget = fromController.getWidgetView() as? TransitionAnimationReady else { return }
        fromWidget.frame = fromViewFrame
        let container = transitionContext.containerView
        let toViewFrameOriginal = anchorView.frame
        let toViewFrame = toController.view.convert(toViewFrameOriginal, from: anchorView.superview ?? UIView())
        fromView.alpha = 0
//        toView.alpha = 0
        container.addSubview(fromWidget)
        fromWidget.prepareForDisappearing()

        fromWidget.animateDisappearing(targetFrame: toViewFrame) {
            UIView.animate(withDuration: 0.3) {
                self.anchorView.alpha = 1
            } completion: { _ in
                fromWidget.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func dismissCalendarWidget(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to),
            let fromController = transitionContext
                .viewController(forKey: .from) as? WidgetContainerViewController else {
            return
        }
        guard let presentationController = fromController.presentationController as? WidgetPresentationController else {
            return
        }
        let fromViewFrame = presentationController.frameOfPresentedViewInContainerView
        anchorView.alpha = 0
        guard let fromWidget = fromController.getWidgetView() as? TransitionAnimationReady else { return }
        fromWidget.frame = fromViewFrame
        let container = transitionContext.containerView
        let toViewFrameOriginal = anchorView.frame
        let toViewFrame = toController.view.convert(toViewFrameOriginal, from: anchorView.superview ?? UIView())
       
        fromView.alpha = 0
//        toView.alpha = 0
        container.addSubview(fromWidget)
        fromWidget.prepareForDisappearing()
        
        UIView.animate(withDuration: 0.4) {
            self.anchorView.alpha = 1
        }
        
        fromWidget.animateDisappearing(targetFrame: toViewFrame) {
                fromWidget.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
    
    func dismissWeightWidget(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to),
            let fromController = transitionContext
                .viewController(forKey: .from) as? WidgetContainerViewController else {
            return
        }
        guard let presentationController = fromController.presentationController as? WidgetPresentationController else {
            return
        }
        let fromViewFrame = presentationController.frameOfPresentedViewInContainerView
        anchorView.alpha = 0
        guard let fromWidget = fromController.getWidgetView() as? TransitionAnimationReady else { return }
        fromWidget.frame = fromViewFrame
        let container = transitionContext.containerView
        let toViewFrameOriginal = anchorView.frame
        let toViewFrame = toController.view.convert(toViewFrameOriginal, from: anchorView.superview ?? UIView())
       
        fromView.alpha = 0
//        toView.alpha = 0
        container.addSubview(fromWidget)
        fromWidget.prepareForDisappearing()
        
        UIView.animate(withDuration: 0.4) {
            self.anchorView.alpha = 1
        }
        
        fromWidget.animateDisappearing(targetFrame: toViewFrame) {
            fromWidget.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissStepsWidget(with transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let fromController = transitionContext
                .viewController(forKey: .from) as? WidgetContainerViewController  else {
            return
        }
        guard let presentationController = fromController.presentationController as? WidgetPresentationController else {
            return
        }
        let container = transitionContext.containerView
        let fromViewFrame = presentationController.frameOfPresentedViewInContainerView
        fromView.alpha = 0
        anchorView.alpha = 0
        let anchorViewFrame = anchorView.frame
        let date = UDM.currentlyWorkingDay.date ?? Date()
        let goal = StepsWidgetService.shared.getDailyStepsGoal()
        let now = StepsWidgetService.shared.getStepsForDate(date)
        let progress = Double(now) / Double(goal ?? 1)
        let fromViewMock = StepsFullWidgetView(frame: fromViewFrame)
        fromViewMock.alpha = 0
        container.addSubview(fromViewMock)
        fromViewMock.setNeedsLayout()
        fromViewMock.layoutIfNeeded()
        let animatableView = StepsWidgetAnimatableContainer(
            initialState: .fullToCompact(
                fullFrame: fromViewFrame,
                steps: Int(now),
                progress: progress,
                fullWidget: fromViewMock
            )
        )
        animatableView.frame = container.bounds
        let compactWidgetMock = StepsWidgetNode(with: .init(type: .compact))
        container.addSubnode(compactWidgetMock)
        compactWidgetMock.frame = anchorViewFrame
        compactWidgetMock.steps = Int(now)
        compactWidgetMock.progress = Double(now) / Double(goal ?? 1)
        compactWidgetMock.setNeedsLayout()
        compactWidgetMock.layoutIfNeeded()
        let progressFrame = compactWidgetMock.getProgressLineFrame()
//        animatableView.frame = container.bounds
        container.addSubview(animatableView)
        animatableView.startTransitionAnimationDisappearing(
            targetView: compactWidgetMock,
            targetFrame: anchorViewFrame
        ) {
            animatableView.removeFromSuperview()
            self.anchorView.alpha = 1
            transitionContext.completeTransition(true)
        }
//        let toViewMock = StepsFullWidgetView(frame: toViewFrame)
//        toViewMock.alpha = 0
//        container.addSubview(toViewMock)
//        toViewMock.setNeedsLayout()
//        toViewMock.layoutIfNeeded()
//        animatableView.startTransitionAnimation(targetView: toViewMock, targetFrame: toViewFrame) { [weak self] in
//            self?.anchorView.alpha = 1
//            UIView.animate(withDuration: 0.3) {
//                animatableView.alpha = 1
//                fromView.alpha = 1
//            } completion: { _ in
//                animatableView.removeFromSuperview()
//                transitionContext.completeTransition(true)
//            }
//        }
    }
}
