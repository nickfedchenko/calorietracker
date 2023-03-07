//
//  CTAlertController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 06.03.2023.
//

import UIKit

final class CTAlertController: UIViewController {
    enum AlertType {
        case newCalorieGoal(newValue: Double, buttonTypes: [ButtonTypes])
    }
    
    enum ButtonTypes {
        case apply(action: (() -> Void)?)
        case cancel(action: (() -> Void)?)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 22)
        label.textAlignment = .center
        label.textColor = UIColor(hex: "192621")
        label.text = makeTitleString()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let containerView: ViewWithShadow = {
        let container = ViewWithShadow(Constants.shadows)
        container.layer.cornerRadius = 14
        container.layer.cornerCurve = .continuous
        container.backgroundColor = .white
        return container
    }()
    
    private var buttons: [UIControl] = []
    
    private lazy var stack: UIStackView = {
       let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8
        switch self.alertType {
        case .newCalorieGoal(newValue: _, buttonTypes: let buttons):
            buttons.forEach {
                switch $0 {
                case .apply(action: let action):
                    let button = BasicButtonView(type: .apply)
                    button.addAction(
                        UIAction { _ in
                            action?()
                        },
                        for: .touchUpInside
                    )
                    button.snp.makeConstraints { make in
                        make.height.equalTo(58)
                    }
                    self.buttons.append(button)
                    stackView.addArrangedSubview(button)
                case .cancel(action: let action):
                    let button = UIButton(type: .system)
                    button.setAttributedTitle(
                        NSAttributedString(
                            string: R.string.localizable.cancel().uppercased(),
                            attributes: [
                                .font: R.font.sfProRoundedBold(size: 20) ?? .systemFont(ofSize: 20),
                                .foregroundColor: UIColor(hex: "0C695E")
                            ]
                        ) ,
                        for: .normal
                    )
                    button.addAction(
                        UIAction { _ in
                            action?()
                        },
                        for: .touchUpInside
                    )
                    button.snp.makeConstraints { make in
                        make.height.equalTo(58)
                    }
                    self.buttons.append(button)
                    stackView.addArrangedSubview(button)
                }
            }
        }
        return stackView
    }()
    
    private let alertType: AlertType
    private let buttonTypes: [ButtonTypes]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appearingAnimation()
    }
    
    init(type: AlertType) {
        self.alertType = type
        switch alertType {
        case .newCalorieGoal(newValue: _, buttonTypes: let types):
            self.buttonTypes = types
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDescription()
        setupSubviews()
    }
    
    private func appearingAnimation() {
        containerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    private func disappearingAnimation(completion: @escaping () -> Void) {
        containerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.snp.bottom)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        disappearingAnimation {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    private func setupSubviews() {
        view.alpha = 0
        view.backgroundColor = UIColor(hex: "004646", alpha: 0.25)
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, descriptionLabel, stack)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.greaterThanOrEqualTo(60)
            make.bottom.equalTo(stack.snp.top).inset(-24)
        }
        
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    private func makeTitleString() -> String {
        switch alertType {
        case .newCalorieGoal:
            return R.string.localizable.settingsCalorieGoalRecalculate()
        }
    }
    
    func makeDescription() {
        switch alertType {
        case .newCalorieGoal(newValue: let value, buttonTypes: _):
            let intValue = Int(value)
            let doubleValue = Double(intValue)
            let valueString = BAMeasurement(doubleValue, .energy).string
            let newString = R.string.localizable.universalSelectorNew()
            let mainString = R.string.localizable.universalSelectorCurrentSettingsByKcalNew() + valueString
            
            descriptionLabel.colorString(
                text: mainString,
                coloredText: [newString, valueString],
                color: UIColor(hex: "E46840"),
                additionalAttributes: [
                    .font: R.font.sfProTextRegular(size: 17) ?? .systemFont(ofSize: 17),
                    .foregroundColor: UIColor(hex: "192621"),
                    .kern: -0.08
                ],
                coloredPartFont: R.font.sfProTextSemibold(size: 17)
            )
        }
    }
}

extension CTAlertController {
    enum Constants {
        static let shadows: [Shadow] = [
            .init(
                color: R.color.widgetShadowColorMainLayer()!,
                opacity: 0.25,
                offset: .init(width: 1, height: 4),
                radius: 10,
                spread: 0
            ),
            .init(
                color: R.color.widgetShadowColorSecondaryLayer()!,
                opacity: 0.2,
                offset: .init(width: 1, height: 0.5),
                radius: 2,
                spread: 0
            )
        ]
    }
}
