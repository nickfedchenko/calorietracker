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
    func setTextFieldFirstResponder()
}

extension KeyboardHeaderProtocol {
    func setTextFieldFirstResponder() {
        guard let textField = subviews.first?.subviews.first(where: { $0 is UITextField }) else {
            return
        }
     
        textField.becomeFirstResponder()
    }
}

final class KeyboardEnterValueViewController: TouchPassingViewController {
    enum KeyboardEnterValueType {
        case weight(WeightKeyboardHeaderView.ActionType)
        case steps
        case standart(String)
        case meal(String, ((String) -> String)?)
        case water
        case settingsKcal
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView?.setTextFieldFirstResponder()
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
        
        headerView?.didChangeValue = { [weak self] value in
            guard let self = self else {return }
            self.enterValue = value
            switch self.type {
            case .weight(let actionType):
                let weight = BAMeasurement(value, .weight).value
                switch actionType {
                case .add:
                    WeightWidgetService.shared.addWeight(weight, to: UDM.currentlyWorkingDay.date)
                    LoggingService.postEvent(event: .weighttrack)
                case .set:
                    WeightWidgetService.shared.setWeightGoal(weight)
                }
            case .steps:
                StepsWidgetService.shared.setDailyStepsGoal(value)
                LoggingService.postEvent(event: .stepssetgoal)
            case .standart, .meal, .water:
                break
            case .settingsKcal:
                return
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
        case .settingsKcal:
            (headerView as? KcalKeyboardHeaderView)?.output = self
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
        case .settingsKcal:
            return KcalKeyboardHeaderView("CALORIE GOAL".localized)
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

extension KeyboardEnterValueViewController: KcalKeyboardHeaderOutput {
    func didTapToRecalculate() -> Double? {
        if let currentWeight = WeightWidgetService.shared.getStartWeight(),
           let gender = UDM.userData?.sex,
           let age = UDM.userData?.dateOfBirth.years(to: Date()),
           let height = UDM.userData?.height {
            let activity = UDM.activityLevel ?? UDM.tempActivityLevel ?? .low
            let normal = CalorieMeasurment.calculationRecommendedCalorieWithoutGoal(
                sex: gender,
                activity: activity,
                age: age,
                height: height,
                weight: currentWeight
            )
            let targetKCal = {
                let weeklyGoal = UDM.weeklyGoal ?? UDM.tempWeeklyGoal ?? 0
                let targetDeficit = weeklyGoal * 1100
                if UDM.goalType == .loseWeight {
                    let targetKcalConsumption = normal - abs(targetDeficit)
                    return targetKcalConsumption
                } else {
                    let targetKcalConsumption = normal + abs(targetDeficit)
                    return targetKcalConsumption
                }
            }()
            return targetKCal
        } else {
            return nil
        }
    }
    
    func didTapToSave(value: Double) {
        dismiss(animated: true) { [weak self] in
            self?.complition?(value)
        }
    }
}
