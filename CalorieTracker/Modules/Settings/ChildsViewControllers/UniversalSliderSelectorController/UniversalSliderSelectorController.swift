//
//  UniversalSliderSelectorController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 03.03.2023.
//

import UIKit

final class UniversalSliderSelectorController: UIViewController {
    private let target: UniversalSliderSelectionTargets
    
    var cancelAction: (() -> Void)?
    var applyAction: ((SettingsCustomizableSliderView.CustomizableSliderViewResult) -> Void)?
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "004646", alpha: 0.25)
        view.alpha = 0
        return view
    }()
    
    private lazy var mainView = SettingsCustomizableSliderView(target: target)
    
    init(target: UniversalSliderSelectionTargets) {
        self.target = target
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent != nil {
            mainView.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.3,
                options: [.curveEaseInOut]
            ) {
                self.dimmingView.alpha = 1
                self.mainView.transform = .identity
            }
        } else {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.3,
                options: [.curveEaseInOut]
            ) {
                self.dimmingView.alpha = 0
                self.mainView.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                self.mainView.alpha = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapToHideKeyboardGesture()
        setupSubviews()
        setupHandlers()
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        mainView.setInitialStates()
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.setInitialStates()
    }
    
    private func setupHandlers() {
        mainView.cancelButtonTapped = { [weak self] in
            self?.cancelAction?()
        }
        mainView.applyButtonTapped = { [weak self] result in
            self?.applyAction?(result)
        }
        
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideController)))
    }
    
    private func setupSubviews() {
        view.addSubviews(dimmingView, mainView)
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(195)
        }
    }
    
    @objc private func hideController() {
        cancelAction?()
    }
}
