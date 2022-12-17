//
//  KeyboardEnterValueViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.12.2022.
//

import UIKit

protocol KeyboardHeaderProtocol: UIView {
    var didTapClose: (() -> Void)? { get set }
    var didChangeValue: ((Double) -> Void)? { get set }
}

final class KeyboardEnterValueViewController: UIViewController {
    enum KeyboardEnterValueType {
        case weight(WeightKeyboardHeaderView.ActionType)
        case steps
        case height
    }
    var needUpdate: (() -> Void)?
    var keyboardManager: KeyboardManagerProtocol = KeyboardManager()
    let type: KeyboardEnterValueType
    
    private var headerView: KeyboardHeaderProtocol?
    private var bottomLayoutConstraint: NSLayoutConstraint?
    
    init(_ type: KeyboardEnterValueType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        headerView = getHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        configureKeyboard()
    }
    
    private func setupView() {
        headerView?.didTapClose = {
            self.dismiss(animated: true)
        }
        
        headerView?.didChangeValue = { value in
            switch self.type {
            case .weight(let actionType):
                let weight = BAMeasurement(value, .weight).value
                switch actionType {
                case .add:
                    WeightWidgetService.shared.addWeight(weight)
                case .set:
                    WeightWidgetService.shared.setWeightGoal(weight)
                }
            case .steps:
                StepsWidgetService.shared.setDailyStepsGoal(value)
            case .height:
                break
            }
            self.needUpdate?()
        }
    }
    
    private func setupConstraint() {
        guard let headerView = headerView else { return }

        view.addSubview(headerView)
        
        bottomLayoutConstraint = headerView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
        bottomLayoutConstraint?.isActive = true
        headerView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
        })
    }
    
    private func configureKeyboard() {
        keyboardManager.bindToKeyboardNotifications(
            superview: view,
            bottomConstraint: bottomLayoutConstraint ?? .init(),
            bottomOffset: 0,
            animated: true
        )
    }
    
    private func getHeaderView() -> KeyboardHeaderProtocol? {
        switch type {
        case .weight(let actionType):
            return WeightKeyboardHeaderView(actionType)
        case .steps:
            return StepsKeyboardHeaderView()
        case .height:
            return HeightKeyboardHeaderView()
        }
    }
}
