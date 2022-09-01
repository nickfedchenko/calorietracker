//
//  PurposeOfTheParishViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable line_length

protocol PurposeOfTheParishViewControllerInterface: AnyObject {
    func set(purposeOfTheParish: [PurposeOfTheParish])
    func set(currentOnboardingStage: OnboardingStage)
}

final class PurposeOfTheParishViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: PurposeOfTheParishPresenterInterface?
    
    // MARK: - Private properties
    
    var isHedden: Bool = false {
        didSet { didChangeIsHeaden() }
    }
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private var answerOptions: [AnswerOption] = []
    private let nextCommonButton: CommonButton = .init(style: .filled, text: "Next".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "History"
        
        view.backgroundColor = R.color.mainBackground()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: "What brings ",
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]
        ))
        attributedString.append(NSAttributedString(
            string: "you here\n now?",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        nextCommonButton.isHidden = true
        nextCommonButton.addTarget(self, action: #selector(didTapNextCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(stackView)
        
        view.addSubview(nextCommonButton)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(32)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
        }
        
        nextCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapAnswerOption(_ sender: AnswerOption) {
        answerOptions.enumerated().forEach { index, answerOption in
            if answerOption == sender {
                let isSelected = !answerOption.isSelected
                
                answerOption.isSelected = isSelected
                
                isSelected ? presenter?.didSelectPurposeOfTheParish(with: index) : presenter?.didDeselectPurposeOfTheParish()
            } else {
                answerOption.isSelected = false
            }
        }
        
        if answerOptions.contains(where: { $0.isSelected == true }) {
            answerOptions.forEach { $0.isTransparent = !$0.isSelected }
        } else {
            answerOptions.forEach { $0.isTransparent = false }
        }
        
        nextCommonButton.isHidden = !answerOptions.contains(where: { $0.isSelected == true })
    }
    
    @objc func didTapNextCommonButton() {
        presenter?.didTapNextCommonButton()
    }
    
    private func didChangeIsHeaden() {
        if isHedden {
            nextCommonButton.isHidden = false
        } else {
            nextCommonButton.isHidden = true
        }
    }
}

// MARK: - PurposeOfTheParishViewControllerInterface

extension PurposeOfTheParishViewController: PurposeOfTheParishViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
    
    func set(purposeOfTheParish: [PurposeOfTheParish]) {
        stackView.removeAllArrangedSubviews()
        answerOptions = []
        
        for purposeOfTheParish in purposeOfTheParish {
            let answerOption = AnswerOption(text: purposeOfTheParish.description)
            
            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
            
            stackView.addArrangedSubview(answerOption)
            answerOptions.append(answerOption)
        }
    }
}

// MARK: - PurposeOfTheParish+description

fileprivate extension PurposeOfTheParish {
    var description: String {
        switch self {
        case .thisTimeToGetBackToHealthyHabits:
            return "It’s time to get back to healthy habits"
        case .iUnhappyWithMyWeight:
            return "I’m unhappy with my weight"
        case .iHaveSomeFreshMotivation:
            return "I have some fresh motivation"
        case .iReadyToStartFeelingGoodAgain:
            return "I’m ready to start feeling good again"
        case .iAmCuriousToCheckOutKcalc:
            return "I am curious to check out Kcalc"
        case .somethingElse:
            return "Something else"
        }
    }
}
