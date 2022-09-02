//
//  JointWeightLossViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation
import UIKit

protocol JointWeightLossViewControllerInterface: AnyObject {
    func set(jointWeightLoss: [JointWeightLoss])
    func set(currentOnboardingStage: OnboardingStage)
}

final class JointWeightLossViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: JointWeightLossPresenterInterface?
    
    // MARK: - Private properties
    
    var isHedden: Bool = false {
        didSet { didChangeIsHeaden() }
    }
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private var answerOptions: [AnswerOption] = []
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "continue".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "Habits"
        
        view.backgroundColor = R.color.mainBackground()
        
        titleLabel.text = "Is your partner also trying to lose weight?"
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        continueCommonButton.isHidden = true
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)

        view.addSubview(titleLabel)
        
        view.addSubview(stackView)
        
        view.addSubview(continueCommonButton)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapAnswerOption(_ sender: AnswerOption) {
        answerOptions.enumerated().forEach { index, answerOption in
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
    
    @objc func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton()
    }
    
    private func didChangeIsHeaden() {
        if isHedden {
            continueCommonButton.isHidden = false
        } else {
            continueCommonButton.isHidden = true
        }
    }
}

// MARK: - JointWeightLossViewControllerInterface

extension JointWeightLossViewController: JointWeightLossViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
    
    func set(jointWeightLoss: [JointWeightLoss]) {
        stackView.removeAllArrangedSubviews()
        answerOptions = []
        
        for jointWeightLoss in jointWeightLoss {
            let answerOption = AnswerOption(text: jointWeightLoss.description)
            
            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
            
            stackView.addArrangedSubview(answerOption)
            answerOptions.append(answerOption)
        }
    }
}

// MARK: - BestDescriptionOfTheSituation + description

fileprivate extension JointWeightLoss {
    var description: String {
        switch self {
        case .yes:
            return "Yes"
        case .imNotSure:
            return "I’m not sure"
        case .no:
            return "No"
        }
    }
}
