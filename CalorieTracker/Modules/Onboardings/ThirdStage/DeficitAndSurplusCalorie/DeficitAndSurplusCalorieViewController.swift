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
    private let sliderBackground: UIView = .init()
    private let firstDotView: UIView = .init()
    private let secondDotView: UIView = .init()
    private let thirdDotView: UIView = .init()
    private let fourthDotView: UIView = .init()
    private let sliderDotsStackView: UIStackView = .init()
    private lazy var sliderThumb: UIView = .init()
    private let resultLabel: UILabel = .init()
    private let rateLabel: UILabel = .init()
    private let procentStackView: UIStackView = .init()
    private let firstProcentLabel: UILabel = .init()
    private let secondProcentLabel: UILabel = .init()
    private let thirdProcentLabel: UILabel = .init()
    private let fourthProcentLabel: UILabel = .init()
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "Continue")
    
    private var weightGoal: WeightGoal?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    // swiftlint:disable:next function_body_length
    private func configureViews() {
        title = "Motivation/Goal"

        view.backgroundColor = R.color.mainBackground()
        
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center
        
        rateLabel.font = .systemFont(ofSize: 18.fontScale(), weight: .bold)
        rateLabel.textColor = R.color.onboardings.basicDark()
        
        resultLabel.font = .systemFont(ofSize: 18.fontScale(), weight: .bold)
        resultLabel.textColor = R.color.onboardings.radialGradientFirst()
        
        sliderBackground.clipsToBounds = false
        
        firstDotView.backgroundColor = .white
        firstDotView.layer.borderWidth = 4
        firstDotView.layer.cornerRadius = 9
        
        secondDotView.backgroundColor = .white
        secondDotView.layer.borderWidth = 4
        secondDotView.layer.cornerRadius = 9
        
        thirdDotView.backgroundColor = .white
        thirdDotView.layer.borderWidth = 4
        thirdDotView.layer.cornerRadius = 9
        
        fourthDotView.backgroundColor = .white
        fourthDotView.layer.borderWidth = 4
        fourthDotView.layer.cornerRadius = 9
        
        sliderDotsStackView.distribution = .equalSpacing
        sliderDotsStackView.axis = .horizontal
        sliderDotsStackView.alignment = .center
        
        sliderThumb.layer.cornerRadius = 15
        sliderThumb.layer.borderWidth = 4
        sliderThumb.layer.borderColor = UIColor(named: R.color.onboardings.basicWhite.name)?.cgColor
        sliderThumb.isUserInteractionEnabled = true
        sliderThumb.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        
        procentStackView.distribution = .equalSpacing
        procentStackView.axis = .horizontal
        procentStackView.alignment = .center
        
        firstProcentLabel.text = "+5%"
        firstProcentLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        secondProcentLabel.text = "+10%"
        secondProcentLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        thirdProcentLabel.text = "+15%"
        thirdProcentLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        fourthProcentLabel.text = "+20%"
        fourthProcentLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        view.addSubview(stageCounterView)
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(currentYourWeightComponent)
        stackView.addArrangedSubview(targetYourWeightComponent)
        
        contentView.addSubview(chartView)
        
        contentView.addSubview(resultLabel)
        
        contentView.addSubview(rateLabel)
        
        contentView.addSubview(sliderBackground)
        
        contentView.addSubview(sliderDotsStackView)
        
        sliderDotsStackView.addArrangedSubview(firstDotView)
        sliderDotsStackView.addArrangedSubview(secondDotView)
        sliderDotsStackView.addArrangedSubview(thirdDotView)
        sliderDotsStackView.addArrangedSubview(fourthDotView)
        
        contentView.addSubview(sliderThumb)
        
        contentView.addSubview(procentStackView)
        
        procentStackView.addArrangedSubview(firstProcentLabel)
        procentStackView.addArrangedSubview(secondProcentLabel)
        procentStackView.addArrangedSubview(thirdProcentLabel)
        procentStackView.addArrangedSubview(fourthProcentLabel)
        
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
        
        chartView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(18)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
        }
        
        rateLabel.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(35)
            $0.left.equalTo(sliderBackground.snp.left).offset(-10)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(35)
            $0.left.equalTo(rateLabel.snp.right).offset(10)
            $0.right.equalTo(sliderBackground.snp.right).offset(10)
        }
        
        sliderBackground.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(26)
            $0.left.equalTo(stackView.snp.left).offset(30)
            $0.right.equalTo(stackView.snp.right).offset(-30)
            $0.height.equalTo(4)
        }
        
        firstDotView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
        
        secondDotView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
        
        thirdDotView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
        
        fourthDotView.snp.makeConstraints {
            $0.size.equalTo(18)
        }
        
        sliderDotsStackView.snp.makeConstraints {
            $0.left.equalTo(sliderBackground.snp.left).offset(-9)
            $0.right.equalTo(sliderBackground.snp.right).offset(9)
            $0.centerY.equalTo(sliderBackground.snp.centerY)
        }
        
        sliderThumb.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.centerX.equalTo(sliderBackground.snp.leading)
            $0.centerY.equalTo(sliderBackground)
        }
        
        procentStackView.snp.makeConstraints {
            $0.top.equalTo(sliderBackground.snp.bottom).offset(12)
            $0.left.equalTo(sliderBackground.snp.left).offset(-15)
            $0.right.equalTo(sliderBackground.snp.right).offset(15)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(procentStackView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc private func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton()
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let stopLocation = sender.location(in: sliderBackground)
        var offset = stopLocation.x
        if offset < 0 { offset = 0 }
        if offset > sliderBackground.bounds.width { offset = sliderBackground.bounds.width }
        
        sliderThumb.snp.updateConstraints { make in
            make.centerX.equalTo(sliderBackground.snp.leading).offset(offset)
        }
        
        if sender.state == UIGestureRecognizer.State.ended {
            let stepWidth = sliderBackground.bounds.width / 3
            
            var currentStep = Int(Double(offset / stepWidth).rounded())
            
            presenter?.didChangeRate(on: Double(5 * (currentStep + 1)))
            
            if (offset - (CGFloat(currentStep) * stepWidth)) > (stepWidth / 2) { currentStep += 1 }
            
            sliderThumb.snp.updateConstraints { make in
                make.centerX.equalTo(sliderBackground.snp.leading).offset(CGFloat(currentStep) * stepWidth)
            }
        }
    }
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
        switch weightGoal {
        case .gain(let calorieSurplus):
            rateLabel.text = "Calorie surplus"
            resultLabel.text = "+\(calorieSurplus.clean) kg per week"
            sliderBackground.backgroundColor = R.color.onboardings.radialGradientFirst()
            sliderThumb.backgroundColor = R.color.onboardings.radialGradientFirst()
            firstDotView.layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
            secondDotView.layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
            thirdDotView.layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
            fourthDotView.layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
            firstProcentLabel.textColor = R.color.onboardings.radialGradientFirst()
            secondProcentLabel.textColor = R.color.onboardings.radialGradientFirst()
            thirdProcentLabel.textColor = R.color.onboardings.radialGradientFirst()
            fourthProcentLabel.textColor = R.color.onboardings.radialGradientFirst()
        case .loss(let calorieDeficit):
            rateLabel.text = "Calorie deficit"
            resultLabel.text = "-\(calorieDeficit.clean) kg per week"
            sliderBackground.backgroundColor = R.color.onboardings.currentWeight()
            sliderThumb.backgroundColor = R.color.onboardings.currentWeight()
            firstDotView.layer.borderColor = R.color.onboardings.currentWeight()?.cgColor
            secondDotView.layer.borderColor = R.color.onboardings.currentWeight()?.cgColor
            thirdDotView.layer.borderColor = R.color.onboardings.currentWeight()?.cgColor
            fourthDotView.layer.borderColor = R.color.onboardings.currentWeight()?.cgColor
            firstProcentLabel.textColor = R.color.onboardings.currentWeight()
            secondProcentLabel.textColor = R.color.onboardings.currentWeight()
            thirdProcentLabel.textColor = R.color.onboardings.currentWeight()
            fourthProcentLabel.textColor = R.color.onboardings.currentWeight()
        }
    }
}
