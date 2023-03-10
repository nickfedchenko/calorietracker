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
        layoutIfNeeded()
        switch target {
        case .weeklyGoal(let numberOfAnchors, _, _):
            let step = bounds.width / (numberOfAnchors - 1)
            let stepRatio = step / bounds.width
            for (index, point) in controlPoints.enumerated() {
                point.backgroundColor = UIColor(hex: "AFBEB8")
                let currentStepRatio = stepRatio * CGFloat(index)
                if  (
                    currentStepRatio - 0.02...currentStepRatio + 0.02
                ).contains(progress) {
                    point.backgroundColor = UIColor(hex: "FF764B")
                }
            }
        case .activityLevel(let numberOfAnchors, _, _):
            let step = bounds.width / (numberOfAnchors - 1)
            let stepRatio = step / bounds.width
            for (index, point) in controlPoints.enumerated() {
                point.backgroundColor = UIColor(hex: "AFBEB8")
                let currentStepRatio = stepRatio * CGFloat(index)
                if  (
                    currentStepRatio - 0.02...currentStepRatio + 0.02
                ).contains(progress) {
                    point.backgroundColor = UIColor(hex: "FF764B")
                }
            }
        }
    }
    
    func setProgress(_ progress: Double) {
        switch target {
        case .weeklyGoal(let numberOfAnchors, _, _):
            let step = bounds.width / (numberOfAnchors - 1)
            let stepRatio = step / bounds.width
            for (index, point) in controlPoints.enumerated() {
                point.backgroundColor = UIColor(hex: "AFBEB8")
                let currentStepRatio = stepRatio * CGFloat(index)
                if  (
                    currentStepRatio - (stepRatio / 2)...currentStepRatio + (stepRatio / 2)
                ).contains(progress) {
                    point.backgroundColor = UIColor(hex: "FF764B")
                }
            }
        case .activityLevel(let numberOfAnchors, _, _):
            let step = bounds.width / (numberOfAnchors - 1)
            let stepRatio = step / bounds.width
            for (index, point) in controlPoints.enumerated() {
                point.backgroundColor = UIColor(hex: "AFBEB8")
                let currentStepRatio = stepRatio * CGFloat(index)
                if  (
                    currentStepRatio - 0.02...currentStepRatio + 0.02
                ).contains(progress) {
                    point.backgroundColor = UIColor(hex: "FF764B")
                }
            }
        }
    }
}

final class SettingsCustomizableSliderView: ViewWithShadow {
    enum CustomizableSliderViewResult: Equatable {
        case activityLevel(selectedLevel: ActivityLevel?, kcalGoal: Double)
        case weeklyGoal(selectedValueInKG: Double?, kcalGoal: Double)
    }
    
    private lazy var tempResult: CustomizableSliderViewResult = {
        switch target {
        case .activityLevel:
            return .activityLevel(
                selectedLevel: UDM.activityLevel ?? UDM.tempActivityLevel, kcalGoal: UDM.kcalGoal ?? 0
            )
        case .weeklyGoal:
            return .weeklyGoal(selectedValueInKG: UDM.weeklyGoal ?? UDM.tempWeeklyGoal, kcalGoal: UDM.kcalGoal ?? 0)
        }
    }()
    
    var applyButtonTapped: ((CustomizableSliderViewResult) -> Void)?
    var cancelButtonTapped: (() -> Void)?
    
    private var target: UniversalSliderSelectionTargets
    private var isFirstLaunch = true
    init(target: UniversalSliderSelectionTargets) {
        self.target = target
        super.init(Constants.shadows)
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
        setupSubviews()
        setupUpdateHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var leftTitle: UILabel = {
        let label = UILabel()
        label.attributedText = target.leftTitle
        return label
    }()
    
    private lazy var rightValueLabel: UILabel = {
        let label = UILabel()
        label.attributedText = {
            switch tempResult {
            case .weeklyGoal(let goal, _):
                return NSAttributedString(
                    string: goal?.clean ?? "",
                    attributes: [
                        .font: R.font.sfProTextSemibold(size: 20) ?? .systemFont(ofSize: 20),
                        .foregroundColor: UIColor(hex: "0C695E")
                    ]
                )
            case .activityLevel(let level, _):
                return NSAttributedString(
                    string: level?.getTitle(.long) ?? "",
                    attributes: [
                        .font: R.font.sfProTextSemibold(size: 20) ?? .systemFont(ofSize: 20),
                        .foregroundColor: UIColor(hex: "0C695E")
                    ]
                )
            }
        }()
        return label
    }()
    
    private lazy var descriptionView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 3
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
    
    private func setupUpdateHandlers() {
        slider.progressEmmiter = updateStatusByProgress(progress:)
    }
    
    private func updateDescriptionLabel() {
        switch tempResult {
        case .weeklyGoal(let value, let newKcalGoal):
            if
                let tempValue = value,
                let storedValue = UDM.weeklyGoal ?? UDM.tempWeeklyGoal {
                if tempValue == storedValue {
                    let string = R.string.localizable.universalSelectorCurrentSettingsByKcal()
                    let calorieGoalString = BAMeasurement(UDM.kcalGoal ?? 0, .energy, isMetric: true).string
                    let fullString = string + calorieGoalString
                    descriptionView.attributedText = NSAttributedString(
                        string: fullString,
                        attributes: [
                            .font: R.font.sfProTextRegular(size: 17) ?? .systemFont(ofSize: 17),
                            .kern: -0.08,
                            .foregroundColor: UIColor(hex: "192621")
                        ]
                    )
                    descriptionView.changeFontFor(textPart: calorieGoalString, font: R.font.sfProTextSemibold(size: 17))
                } else {
                    
                    let baseString = R.string.localizable.universalSelectorCurrentSettingsByKcalNew()
                    let newString = R.string.localizable.universalSelectorNew()
                    
                    let calorieGoalString = BAMeasurement(
                        newKcalGoal, .energy, isMetric: true
                    ).string
                    
                    let fullString = baseString + calorieGoalString
                    
                    descriptionView.colorString(
                        text: fullString,
                        coloredText: [newString, calorieGoalString],
                        color: UIColor(hex: "E46840"),
                        additionalAttributes: [
                            .font: R.font.sfProTextRegular(size: 17) ?? .systemFont(ofSize: 17),
                            .kern: -0.08,
                            .foregroundColor: UIColor(hex: "192621")
                        ],
                        coloredPartFont: R.font.sfProTextSemibold(size: 17)
                    )
                }
            }
        case .activityLevel(selectedLevel: let level, let kcalGoal):
            if
                let storedLevel = UDM.activityLevel,
                let tempLevel = level,
                storedLevel == level {
                let string = R.string.localizable.universalSelectorCurrentSettingsByKcal()
                let calorieGoalString = BAMeasurement(kcalGoal, .energy, isMetric: true).string
                let fullString = string + calorieGoalString
                descriptionView.attributedText = NSAttributedString(
                    string: fullString,
                    attributes: [
                        .font: R.font.sfProTextRegular(size: 17) ?? .systemFont(ofSize: 17),
                        .kern: -0.08,
                        .foregroundColor: UIColor(hex: "192621")
                    ]
                )
                descriptionView.changeFontFor(textPart: calorieGoalString, font: R.font.sfProTextSemibold(size: 17))
            } else {
                let baseString = R.string.localizable.universalSelectorCurrentSettingsByKcalNew()
                let newString = R.string.localizable.universalSelectorNew()
                
                let calorieGoalString = BAMeasurement(
                    kcalGoal, .energy, isMetric: true
                ).string
                
                let fullString = baseString + calorieGoalString
                
                descriptionView.colorString(
                    text: fullString,
                    coloredText: [newString, calorieGoalString],
                    color: UIColor(hex: "E46840"),
                    additionalAttributes: [
                        .font: R.font.sfProTextRegular(size: 17) ?? .systemFont(ofSize: 17),
                        .kern: -0.08,
                        .foregroundColor: UIColor(hex: "192621")
                    ],
                    coloredPartFont: R.font.sfProTextSemibold(size: 17)
                )
            }
        }
    }
    
    private func calculateNewTempResult(
        forNew progress: Double
    ) {
        switch target {
        case .weeklyGoal:
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
                
                let targetCalorieDailyOffset = 1100 * progress
                var newKcalGoal = UDM.goalType == .loseWeight
                ? normal - targetCalorieDailyOffset
                : normal + targetCalorieDailyOffset
                tempResult = .weeklyGoal(selectedValueInKG: progress, kcalGoal: newKcalGoal)
            }
        case .activityLevel(_, let lowerBoundValue, let upperBoundValue):
            let possibleValues: [ActivityLevel] = [.low, .moderate, .high, .veryHigh]
            let targetIndex = Int((upperBoundValue - lowerBoundValue) * progress)
            let newActivityLevel = possibleValues[targetIndex]
            if let currentWeight = WeightWidgetService.shared.getStartWeight(),
               let gender = UDM.userData?.sex,
               let age = UDM.userData?.dateOfBirth.years(to: Date()),
               let height = UDM.userData?.height {
                let normal = CalorieMeasurment.calculationRecommendedCalorieWithoutGoal(
                    sex: gender,
                    activity: newActivityLevel,
                    age: age,
                    height: height,
                    weight: currentWeight
                )
                var finalTargetKcal = normal
                let correction = ((UDM.weeklyGoal ?? 0.1) * 7700) / 7
                finalTargetKcal = normal + correction
                tempResult = .activityLevel(selectedLevel: newActivityLevel, kcalGoal: finalTargetKcal )
            }
        }
    }
    
    private func updateStatusByProgress(progress: CGFloat) {
        calculateNewTempResult(forNew: progress)
        controlPointsView.setProgress(progress)
        updateValueLabel()
        updateDescriptionLabel()
    }
    
    
    func setInitialStates() {
        switch target {
        case .weeklyGoal(let numberOfAnchors, _, _):
            let weeklyGoal = abs(UDM.weeklyGoal ?? UDM.tempWeeklyGoal ?? 0.1)
            controlPointsView.setViewsInitially(at: weeklyGoal)
            controlPointsView.setProgress(weeklyGoal)
            slider.setProgress(weeklyGoal)
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
        updateDescriptionLabel()
    }
    
    private func updateValueLabel() {
        switch tempResult {
        case .weeklyGoal(let progress, _):
            var targetValue = progress ?? 0
            if UDM.goalType == .loseWeight {
                targetValue *= -1
            }
            let targetString = BAMeasurement(targetValue, .weight, isMetric: true).string
            rightValueLabel.attributedText = NSAttributedString(
                string: targetString,
                attributes: [
                    .font: R.font.sfProTextSemibold(size: 20) ?? .systemFont(ofSize: 20),
                    .foregroundColor: UIColor(hex: "0C695E"),
                    .kern: -0.41
                ]
            )
        case .activityLevel(let activity, _):
            //                let possibleValues: [ActivityLevel] = [.low, .moderate, .high, .veryHigh]
            //                let targetIndex = Int((upperBoundValue - lowerBoundValue) * progress)
            rightValueLabel.attributedText = NSAttributedString(
                string: activity?.getTitle(.short) ?? "",
                attributes: [
                    .font: R.font.sfProTextSemibold(size: 20) ?? .systemFont(ofSize: 20),
                    .foregroundColor: UIColor(hex: "0C695E"),
                    .kern: -0.41
                ]
            )
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
            make.top.equalTo(slider.snp.bottom).offset(162)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(applyButton)
            make.top.equalTo(applyButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(58)
        }
    }
    
    @objc private func applyTapped(sender: BasicButtonView) {
        applyButtonTapped?(tempResult)
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
