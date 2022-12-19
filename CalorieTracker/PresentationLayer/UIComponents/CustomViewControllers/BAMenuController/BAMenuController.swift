//
//  BAMenuController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import UIKit

class BAMenuController: UIViewController {
    private let menuView: UIView
    private let frame: CGRect
    
    init(_ view: UIView, frame: CGRect) {
        self.menuView = view
        self.frame = frame
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(menuView)
        
        menuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension BAMenuController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        BAMenuPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            frame: self.frame
        )
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
