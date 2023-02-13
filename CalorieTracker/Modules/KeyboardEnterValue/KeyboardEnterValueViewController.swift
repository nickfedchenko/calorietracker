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

final class KeyboardEnterValueViewController: TouchPassingViewController {
    enum KeyboardEnterValueType {
        case weight(WeightKeyboardHeaderView.ActionType)
        case steps
        case standart(String)
        case meal(String, ((String) -> String)?)
        case water
    }
    var needUpdate: (() -> Void)?
    var complition: ((Double) -> Void)?
    var waterComplition: ((QuickAddModel) -> Void)?
    var keyboardManager: KeyboardManagerProtocol = KeyboardManager()
    let type: KeyboardEnterValueType
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        recognizer.cancelsTouchesInView = true
        return recognizer
    }()
    
    private var headerView: KeyboardHeaderProtocol?
    private var bottomLayoutConstraint: NSLayoutConstraint?
    private var enterValue: Double?
    
    init(_ type: KeyboardEnterValueType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
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
        setupOutput()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let enterValue = enterValue else {
            return
        }

        self.complition?(enterValue)
    }
    
    private func setupView() {
        headerView?.didTapClose = {
            self.dismiss(animated: true)
        }
        
        headerView?.didChangeValue = { value in
            self.enterValue = value
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
            case .standart, .meal, .water:
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
    
    private func setupOutput() {
        switch type {
        case .weight:
            return
        case .steps:
            return
        case .standart:
            return
        case .meal:
            return
        case .water:
            (headerView as? WaterKeyboardHeaderView)?.output = self
        }
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
        case .standart(let title):
            return StandartKeyboardHeaderView(title)
        case .meal(let title, let complition):
            return MealKeyboardHeaderView(title, complition: complition)
        case .water:
            return WaterKeyboardHeaderView("")
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

extension KeyboardEnterValueViewController: WaterKeyboardHeaderOutput {
    func saveModel(_ model: QuickAddModel) {
        waterComplition?(model)
    }
}

extension KeyboardEnterValueViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        WidgetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            insets: .zero
        )
    }
}
