//
//  OpenMainWidgetPresentController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.02.2023.
//

import UIKit

final class OpenMainWidgetPresentController: UIPresentationController {
    
    enum State {
        case modal
        case full
    }
    
    var handleTapView: (() -> Void)?
    
    var state: State = .modal {
        didSet {
            didChangeState()
        }
    }
    private let topInset: CGFloat
    private var topZeroConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?

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
    
    init(
        presentedViewController: UIViewController,
        presenting: UIViewController?,
        topInset: CGFloat
    ) {
        self.topInset = topInset
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
        
        topZeroConstraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0)
        topConstraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topInset)
        presentedView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        topConstraint?.isActive = true
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
            UIView.animate(withDuration: 0.3, delay: 0) {
                animation()
            }
            return
        }

        coordinator.animate { _ in
            animation()
        }
    }
    
    private func didChangeState() {
        guard let presentedView = presentedView else { return }
        presentedView.layer.maskedCorners = .topCorners
        
        switch self.state {
        case .modal:
            presentedView.layer.cornerRadius = 40
            self.topConstraint?.isActive = true
            self.topZeroConstraint?.isActive = false
        case .full:
            presentedView.layer.cornerRadius = 0
            self.topConstraint?.isActive = false
            self.topZeroConstraint?.isActive = true
        }

        performAlongsideTransitionIfPossible {
            self.presentedView?.layoutIfNeeded()
            self.containerView?.layoutIfNeeded()
        }
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        handleTapView?()
    }
}
