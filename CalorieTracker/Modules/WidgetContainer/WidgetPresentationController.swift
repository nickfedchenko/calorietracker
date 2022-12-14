//
//  WidgetPresentationController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 15.12.2022.
//

import UIKit

final class WidgetPresentationController: UIPresentationController {

    private lazy var dimmView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = R.color.foodViewing.basicPrimary()?.withAlphaComponent(0.25)
        view.addGestureRecognizer(tapRecognizer)
        return view
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        recognizer.cancelsTouchesInView = true
        return recognizer
    }()
    
    private let controllerInsets: UIEdgeInsets
    
    init(
        presentedViewController: UIViewController,
        presenting: UIViewController?,
        insets: UIEdgeInsets = .zero
    ) {
        self.controllerInsets = insets
        super.init(
            presentedViewController: presentedViewController,
            presenting: presenting
        )
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView = containerView,
               let presentedView = presentedView else { return }

        containerView.addSubviews(dimmView, presentedView)

        dimmView.alpha = 0
        performAlongsideTransitionIfPossible {
            self.dimmView.alpha = 1
        }

        dimmView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        presentedView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(controllerInsets.top)
            make.left.equalToSuperview().offset(controllerInsets.left)
            make.right.equalToSuperview().offset(-controllerInsets.right)
            make.bottom.equalToSuperview().offset(-controllerInsets.bottom)
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmView.removeFromSuperview()
            presentedView?.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        performAlongsideTransitionIfPossible {
            self.dimmView.alpha = 0
        }
    }

    private func performAlongsideTransitionIfPossible(_ animation: @escaping () -> Void ) {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            animation()
            return
        }

        coordinator.animate { _ in
            animation()
        }
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
