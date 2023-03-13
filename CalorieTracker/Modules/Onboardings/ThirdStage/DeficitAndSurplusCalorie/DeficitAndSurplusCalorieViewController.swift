//
//  DeficitAndSurplusCalorieViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 05.09.2022.
//

import Foundation
import UIKit

protocol DeficitAndSurplusCalorieViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
    func set(yourWeight: Double)
    func set(yourGoalWeight: Double)
    func set(weightGoal: WeightGoal)
    func set(date: Date)
}

final class DeficitAndSurplusCalorieViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: DeficitAndSurplusCaloriePresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let stackView: UIStackView = .init()
    private let currentYourWeightComponent: YourWeightComponent = .init(style: .current)
    private let targetYourWeightComponent: YourWeightComponent = .init(style: .target)
    private let chartView: OnboardingChartView = .init()
    
    private lazy var sliderView: SettingsCustomizableSliderView = SettingsCustomizableSliderView(
        target: .weeklyGoal(
            numberOfAnchors: 21, lowerBoundValue: 0, upperBoundValue: 1), mode: .compact(
                goalType: presenter?.getGoal() ?? .loss(calorieDeficit: 0)
            )
    )

    private let continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingThirdDeficitAndSurplusCalorieButton()
    )
    
    private var weightGoal: WeightGoal?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sliderView.setInitialStates()
        sliderView.standaloneRatioEmitter = { [weak self] ratio in
            self?.presenter?.didChangeRate(on: ratio)
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func configureViews() {
        title = R.string.localizable.onboardingThirdDeficitAndSurplusCalorieTitle()

        view.backgroundColor = R.color.mainBackground()
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(currentYourWeightComponent)
        stackView.addArrangedSubview(targetYourWeightComponent)
        
        contentView.addSubview(chartView)
        contentView.addSubview(sliderView)

        contentView.addSubview(continueCommonButton)
        
        scrolView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrolView.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(scrolView.snp.bottom)
            $0.height.greaterThanOrEqualTo(scrolView.snp.height)
        }
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
        }
        
        currentYourWeightComponent.snp.makeConstraints {
            $0.width.equalTo(targetYourWeightComponent.snp.width)
        }
        
        targetYourWeightComponent.aspectRatio()
        
        chartView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(18)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
        }
        
        sliderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(chartView.snp.bottom).offset(16)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(sliderView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc private func didTapContinueCommonButton() {
        if let weightGoal = weightGoal {
            presenter?.didTapContinueCommonButton(with: weightGoal)
        }
    }
    
//    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
//        let stopLocation = sender.location(in: sliderBackground)
//        var offset = stopLocation.x
//        if offset < 0 { offset = 0 }
//        if offset > sliderBackground.bounds.width { offset = sliderBackground.bounds.width }
//
//        sliderThumb.snp.updateConstraints { make in
//            make.centerX.equalTo(sliderBackground.snp.leading).offset(offset)
//        }
//
//        if sender.state == UIGestureRecognizer.State.ended {
//            let stepWidth = sliderBackground.bounds.width / 3
//
//            var currentStep = Int(Double(offset / stepWidth).rounded())
//
//            presenter?.didChangeRate(on: Double(5 * (currentStep + 1)))
//
//            if (offset - (CGFloat(currentStep) * stepWidth)) > (stepWidth / 2) { currentStep += 1 }
//
//            sliderThumb.snp.updateConstraints { make in
//                make.centerX.equalTo(sliderBackground.snp.leading).offset(CGFloat(currentStep) * stepWidth)
//            }
//        }
//    }
}

extension DeficitAndSurplusCalorieViewController: DeficitAndSurplusCalorieViewControllerInterface {
    func set(date: Date) {
        guard let weightGoal = weightGoal else { return }
        chartView.configure(
            date: date,
            weightGoal: weightGoal
        )
    }
    
    func set(yourWeight: Double) {
        targetYourWeightComponent.set(yourCurrentWeight: yourWeight)
    }
    
    func set(yourGoalWeight: Double) {
        currentYourWeightComponent.set(yourTargetWeight: yourGoalWeight)
    }
    
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
    
    func set(weightGoal: WeightGoal) {
        self.weightGoal = weightGoal
        let suffix = R.string.localizable.onboardingThirdDeficitAndSurplusCalorieResult()
        switch weightGoal {
        case .gain(let calorieSurplus):
            return
//            rateLabel.text = R.string.localizable.onboardingThirdDeficitAndSurplusCalorieSurplus()
//            resultLabel.text = "+\(calorieSurplus.clean) \(suffix)"
//            sliderBackground.backgroundColor = R.color.onboardings.radialGradientFirst()
//            sliderThumb.backgroundColor = R.color.onboardings.radialGradientFirst()
//            firstDotView.layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
//            secondDotView.layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
//            thirdDotView.layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
//            fourthDotView.layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
//            firstProcentLabel.textColor = R.color.onboardings.radialGradientFirst()
//            secondProcentLabel.textColor = R.color.onboardings.radialGradientFirst()
//            thirdProcentLabel.textColor = R.color.onboardings.radialGradientFirst()
//            fourthProcentLabel.textColor = R.color.onboardings.radialGradientFirst()
        case .loss(let calorieDeficit):
            return
//            rateLabel.text = R.string.localizable.onboardingThirdDeficitAndSurplusCalorieDeficit()
//            resultLabel.text = "-\(calorieDeficit.clean) \(suffix)"
//            sliderBackground.backgroundColor = R.color.onboardings.currentWeight()
//            sliderThumb.backgroundColor = R.color.onboardings.currentWeight()
//            firstDotView.layer.borderColor = R.color.onboardings.currentWeight()?.cgColor
//            secondDotView.layer.borderColor = R.color.onboardings.currentWeight()?.cgColor
//            thirdDotView.layer.borderColor = R.color.onboardings.currentWeight()?.cgColor
//            fourthDotView.layer.borderColor = R.color.onboardings.currentWeight()?.cgColor
//            firstProcentLabel.textColor = R.color.onboardings.currentWeight()
//            secondProcentLabel.textColor = R.color.onboardings.currentWeight()
//            thirdProcentLabel.textColor = R.color.onboardings.currentWeight()
//            fourthProcentLabel.textColor = R.color.onboardings.currentWeight()
        }
    }
}
