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
    
    private var state: State = .modal {
        didSet {
            didChangeState()
        }
    }
    
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
    
    override init(
        presentedViewController: UIViewController,
        presenting: UIViewController?
    ) {
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
        topConstraint = presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0)
        presentedView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
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
    
    private func didChangeState() {
        guard let presentedView = presentedView else { return }
        
        performAlongsideTransitionIfPossible {
            switch self.state {
            case .modal:
                presentedView.layer.cornerRadius = 40
            case .full:
                presentedView.layer.cornerRadius = 0
            }
        }
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        handleTapView?()
    }
}
