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
    private let anchorPoint: CGPoint
    private var controllerFrame: CGRect?
    
    private var firstDraw = true
    
    init(_ view: MenuViewProtocol, width: CGFloat, anchorPoint: CGPoint) {
        self.menuView = view
        self.width = width
        self.anchorPoint = anchorPoint
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
        
        self.controllerFrame = getViewFrame()
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
    
    private func getViewFrame() -> CGRect {
        CGRect(
            origin: anchorPoint,
            size: menuView.systemLayoutSizeFitting(
                CGSize(width: width, height: .leastNormalMagnitude),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .defaultLow
            )
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
            controllerFrame: self.controllerFrame ?? .zero
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
        BAMenuPresentTransition(self.controllerFrame ?? .zero)
    }

    func animationController(
        forDismissed _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        BAMenuDismissTransition()
    }
}
