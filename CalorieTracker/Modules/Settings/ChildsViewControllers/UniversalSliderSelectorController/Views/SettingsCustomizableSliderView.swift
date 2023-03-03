//
//  SDettingsCustomizableSliderView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 03.03.2023.
//

import UIKit

final class AnchorPointsView: UIView {
    private var target: UniversalSliderSelectionTargets
    
    init(target: UniversalSliderSelectionTargets) {
        self.target = target
        super.init(frame: .zero)
    }
    
    lazy var controlPoints: [UIView] = {
        switch target {
        case .weeklyGoal(let numberOfAnchors, let lowerBoundValue, let upperBoundValue):
            var views: [UIView] = []
            for i in 0..<Int(numberOfAnchors) {
                let view = UIView()
                view.backgroundColor = UIColor(hex: "AFBEB8")
                view.snp.makeConstraints { make in
                    make.width.height.equalTo(3)
                }
                view.layer.cornerRadius = 3 / 2
                view.layer.cornerCurve = .circular
                views.append(view)
            }
            return views
        case .activityLevel(let numberOfAnchors, let lowerBoundValue, let upperBoundValue):
            var views: [UIView] = []
            for i in 0..<Int(numberOfAnchors) {
                let view = UIView()
                view.backgroundColor = UIColor(hex: "AFBEB8")
                view.snp.makeConstraints { make in
                    make.width.equalTo(3)
                    make.height.equalTo(9)
                }
                view.layer.cornerRadius = 3 / 2
                view.layer.cornerCurve = .circular
                views.append(view)
            }
            return views
        }
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewsInitially(at progress: Double) {
        var offset: CGFloat = 3
        var step: CGFloat = 0
        switch target {
        case .weeklyGoal(let numberOfAnchors, _, _):
           step = (bounds.width - offset) / (numberOfAnchors - 1)
         
        case .activityLevel(let numberOfAnchors, _, _):
            step = (bounds.width - offset) / (numberOfAnchors - 1)
        }
        
        for (index, point) in controlPoints.enumerated() {
            addSubview(point)
            point.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(CGFloat(index) * step)
            }
        }
        
        switch target {
        case .weeklyGoal(let numberOfAnchors, _, _):
            let step = bounds.width / numberOfAnchors - 1
            let stepRatio = step / bounds.width
            for (index, point) in controlPoints.enumerated() {
                point.backgroundColor = UIColor(hex: "AFBEB8")
                let currentStepRatio = step * CGFloat(index)
                if (currentStepRatio - (step - 0.02)...currentStepRatio + (step - 0.02)).contains(progress) {
                  point.backgroundColor = UIColor(hex: "FF764B")
                }
            }
        case .activityLevel(let numberOfAnchors, _, _):
            let step = bounds.width / numberOfAnchors - 1
            let stepRatio = step / bounds.width
            for (index, point) in controlPoints.enumerated() {
                point.backgroundColor = UIColor(hex: "AFBEB8")
                let currentStepRatio = step * CGFloat(index)
                if (currentStepRatio - (step - 0.02)...currentStepRatio + (step - 0.02)).contains(progress) {
                    point.backgroundColor = UIColor(hex: "FF764B")
                }
            }
        }
    }
    
    func setProgress(_ progress: Double) {
        
    }
    
}

final class SettingsCustomizableSliderView: ViewWithShadow {
    var applyButtonTapped: (() -> Void)?
    var cancelButtonTapped: (() -> Void)?
    
    private var target: UniversalSliderSelectionTargets

    init(target: UniversalSliderSelectionTargets) {
        self.target = target
        super.init(Constants.shadows)
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
        setupSubviews()
    }
    
    private lazy var leftTitle: UILabel = {
        let label = UILabel()
        label.attributedText = target.leftTitle
        return label
    }()
    
    private lazy var rightValueLabel: UILabel = {
        let label = UILabel()
        label.attributedText = {
            switch target {
            case .weeklyGoal:
                return NSAttributedString(
                    string: UDM.weeklyGoal?.clean ?? "",
                    attributes: [
                        .font: R.font.sfProTextSemibold(size: 20) ?? .systemFont(ofSize: 20),
                        .foregroundColor: UIColor(hex: "0C695E")
                    ]
                )
            case .activityLevel:
                return NSAttributedString(
                    string: UDM.activityLevel?.getTitle(.long) ?? "",
                    attributes: [
                        .font: R.font.sfProTextSemibold(size: 20) ?? .systemFont(ofSize: 20),
                        .foregroundColor: UIColor(hex: "0C695E")
                    ]
                )
            }
        }()
        return label
    }()
    
    private let descriptionView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "asfasdfkaskdfjwgjsdjflasjljasd"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var applyButton: BasicButtonView = {
        let button = BasicButtonView(type: .apply)
        button.addTarget(self, action: #selector(applyTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
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
        button.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var controlPointsView: AnchorPointsView = AnchorPointsView(target: target)
    private lazy var slider = SliderLineView(target: target)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInitialStates() {
        switch target {
        case .weeklyGoal(let numberOfAnchors, _, _):
            let weeklyGoal = abs(UDM.weeklyGoal ?? 0.1)
            slider.setProgress(weeklyGoal)
            controlPointsView.setViewsInitially(at: weeklyGoal)
        case .activityLevel(let numberOfAnchors, _, _):
            switch UDM.activityLevel {
            case .low:
                slider.setProgress(0)
                controlPointsView.setViewsInitially(at: 0)
            case .moderate:
                slider.setProgress(0.33)
                controlPointsView.setViewsInitially(at: 0.33)
            case .high:
                slider.setProgress(0.66)
                controlPointsView.setViewsInitially(at: 0.66)
            case .veryHigh:
                slider.setProgress(1)
                controlPointsView.setViewsInitially(at: 1)
            default:
                slider.setProgress(0)
                controlPointsView.setViewsInitially(at: 0)
            }
        }
    }
    
    private func setupSubviews() {
        backgroundColor = .white
        addSubviews(leftTitle, rightValueLabel, controlPointsView, slider, descriptionView, applyButton, cancelButton)
        leftTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.top.equalToSuperview().offset(24)
        }
        
        rightValueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(24)
        }
        
        controlPointsView.snp.makeConstraints { make in
            var height: CGFloat = 0
            switch self.target {
            case .activityLevel:
                height = 9
            case .weeklyGoal:
                height = 3
            }
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(leftTitle.snp.bottom).offset(27)
            make.height.equalTo(height)
        }
        
        slider.snp.makeConstraints { make in
            make.leading.trailing.equalTo(controlPointsView)
            make.top.equalTo(controlPointsView.snp.bottom).offset(4)
            make.height.equalTo(32)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(slider.snp.bottom).offset(57)
        }
        
        applyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
            make.top.equalTo(descriptionView.snp.bottom).offset(45)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(applyButton)
            make.top.equalTo(applyButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func applyTapped(sender: BasicButtonView) {
        applyButtonTapped?()
    }
    
    @objc private func cancelButtonTapped(sender: UIButton) {
        cancelButtonTapped?()
    }
}


extension SettingsCustomizableSliderView {
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
