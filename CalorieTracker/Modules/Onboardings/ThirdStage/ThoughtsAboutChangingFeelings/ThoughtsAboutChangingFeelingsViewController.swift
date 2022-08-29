//
//  ThoughtsAboutChangingFeelingsViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation
import UIKit

protocol ThoughtsAboutChangingFeelingsViewControllerInterface: AnyObject {
    func set(thoughtsAboutChangingFeelings: [ThoughtsAboutChangingFeelings])
}

final class ThoughtsAboutChangingFeelingsViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: ThoughtsAboutChangingFeelingsPresenterInterface?
    
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
        title = "Motivation/Goal"
        
        view.backgroundColor = R.color.mainBackground()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: "When you think about changing how you feel,\n what’s ",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        
        attributedString.append(NSAttributedString(
            string: "most important?",
            attributes: [.foregroundColor:  R.color.onboardings.radialGradientFirst()]
        ))
        
        titleLabel.attributedText = attributedString
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
            $0.left.equalTo(view.snp.left).offset(100)
            $0.right.equalTo(view.snp.right).offset(-100)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
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

// MARK: - ThoughtsAboutChangingFeelingsViewControllerInterface

extension ThoughtsAboutChangingFeelingsViewController: ThoughtsAboutChangingFeelingsViewControllerInterface {
    func set(thoughtsAboutChangingFeelings: [ThoughtsAboutChangingFeelings]) {
        stackView.removeAllArrangedSubviews()
        answerOptions = []
        
        for thoughtsAboutChangingFeelings in thoughtsAboutChangingFeelings {
            let answerOption = AnswerOption(text: thoughtsAboutChangingFeelings.description)
            
            answerOption.addTarget(self, action: #selector(didTapAnswerOption), for: .touchUpInside)
            
            stackView.addArrangedSubview(answerOption)
            answerOptions.append(answerOption)
        }
    }
}

// MARK: - ThoughtsAboutChangingFeelings + description

fileprivate extension ThoughtsAboutChangingFeelings {
    var description: String {
        switch self {
        case .havingMoreEnergy:
            return "Having more energy"
        case .feelingBetterInMyClothes:
            return "Feeling better in my clothes"
        case .havingMoreConfidence:
            return "Having more confidence"
        case .physicallyFeelingMoreComfortable:
            return "Physically feeling more comfortable"
        }
    }
}
