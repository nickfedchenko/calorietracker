//
//  BAMenuController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import UIKit

protocol MenuViewProtocol: UIView {
    func closeNotAnimate()
    func showAndCloseView(_ flag: Bool)
    var didClose: (() -> Void)? { get set }
}

class BAMenuController: UIViewController {
    private let menuView: MenuViewProtocol
    private let width: CGFloat
    private var controllerSize: CGSize?
    
    private var firstDraw = true
    
    var anchorPoint: CGPoint?
    var didClose: (() -> Void)?
    
    init(_ view: MenuViewProtocol, width: CGFloat) {
        self.menuView = view
        self.width = width
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
        
        self.controllerSize = getViewSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard firstDraw else { return }
        firstDraw = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuView.closeNotAnimate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        menuView.showAndCloseView(true)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        didClose?()
    }
    
    private func setupView() {
        menuView.isHidden = true
        menuView.didClose = {
            self.dismiss(animated: true)
        }
        
        view.addSubview(menuView)
        
        menuView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    private func getViewSize() -> CGSize {
        menuView.systemLayoutSizeFitting(
            CGSize(width: width, height: .leastNormalMagnitude),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
    }
}

extension BAMenuController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = BAMenuPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            controllerFrame: CGRect(
                origin: anchorPoint ?? .zero,
                size: controllerSize ?? .zero
            )
        )
        
        presentationController.handleTapView = {
            self.menuView.showAndCloseView(false)
        }
        
        return presentationController
    }
    
    func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        BAMenuPresentTransition()
    }

    func animationController(
        forDismissed _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        BAMenuDismissTransition()
    }
}
