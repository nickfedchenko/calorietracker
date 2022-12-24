//
//  LifeChangesAfterWeightLossViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation
import UIKit

protocol LifeChangesAfterWeightLossViewControllerInterface: AnyObject {
    func set(lifeChangesAfterWeightLoss: [LifeChangesAfterWeightLoss])
    func set(currentOnboardingStage: OnboardingStage)
}

final class LifeChangesAfterWeightLossViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: LifeChangesAfterWeightLossPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private var answerOptions: [AnswerOption] = []
    private let continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingThirdLifeChangesAfterWeightLossButton().uppercased()
    )
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = R.string.localizable.onboardingThirdLifeChangesAfterWeightLossTitle()

        view.backgroundColor = R.color.mainBackground()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingThirdLifeChangesAfterWeightLossTitleFirst(),
            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
        ))
        
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingThirdLifeChangesAfterWeightLossTitleSecond(),
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(stackView)
        
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(43)
            $0.right.equalTo(contentView.snp.right).offset(-43)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.left.equalTo(contentView.snp.left).offset(32)
            $0.right.equalTo(contentView.snp.right).offset(-32)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapAnswerOption(_ sender: AnswerOption) {
        answerOptions.forEach { answerOption in
            if answerOption == sender {
                let isSelected = !answerOption.isSelected
                
                answerOption.isSelected = isSelected
                
            } else {
                answerOption.isSelected = false
            }
        }
        
        if answerOptions.contains(where: { $0.isSelected == true }) {
            answerOptions.forEach { $0.isTransparent = !$0.isSelected }
        } else {
            answerOptions.forEach { $0.isTransparent = false }
        }
        
        continueCommonButton.isHidden = !answerOptions.contains(where: { $0.isSelected == true })
    }
    
    @objc func didTapContinueCommonButton(_ sender: AnswerOption) {
        presenter?.didTapContinueCommonButton()
    }
}

// MARK: - LifeChangesAfterWeightLossViewControllerInterface

extension LifeChangesAfterWeightLossViewController: LifeChangesAfterWeightLossViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
    
    func set(lifeChangesAfterWeightLoss: [LifeChangesAfterWeightLoss]) {
        stackView.removeAllArrangedSubviews()
        answerOptions = []
        
        for lifeChangesAfterWeightLoss in lifeChangesAfterWeightLoss {
            let answerOption = AnswerOption(text: lifeChangesAfterWeightLoss.description)
            
            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
            
            stackView.addArrangedSubview(answerOption)
            answerOptions.append(answerOption)
        }
    }
}

// MARK: - LifeChangesAfterWeightLoss + description

fileprivate extension LifeChangesAfterWeightLoss {
    var description: String {
        switch self {
        case .beingProudOfMyself:
            return R.string.localizable.onboardingThirdLifeChangesAfterWeightLossBeingProudOfMyself()
        case .feelingGreat:
            return R.string.localizable.onboardingThirdLifeChangesAfterWeightLossFeelingGreat()
        case .wearingDifferentClothes:
            return R.string.localizable.onboardingThirdLifeChangesAfterWeightLossWearingDifferentClothes()
        case .havingBetterHealthMetrics:
            return R.string.localizable.onboardingThirdLifeChangesAfterWeightLossHavingBetterHealthMetrics()
        case .settingGoodExampleForOthers:
            return R.string.localizable.onboardingThirdLifeChangesAfterWeightLossSettingGoodExampleForOthers()
        case .havingMoreEnergy:
            return R.string.localizable.onboardingThirdLifeChangesAfterWeightLossHavingMoreEnergy()
        case .beingMoreFit:
            return R.string.localizable.onboardingThirdLifeChangesAfterWeightLossBeingMoreFit()
        }
    }
}
