//
//  ReflectToAchievedSomethingDifficultViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable line_length


protocol ReflectToAchievedSomethingDifficultViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class ReflectToAchievedSomethingDifficultViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: ReflectToAchievedSomethingDifficultPresenterInterface?
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let stackView: UIStackView = .init()
    private let titleLabel: UILabel = .init()
    private let firstDescriptionLabel: UILabel = .init()
    private let secondDescriptionLabel: UILabel = .init()
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "Continue".uppercased())
    
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
        
        titleLabel.text = "Reflect on the last \ntime you achieved something difficult."
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        firstDescriptionLabel.text = "What made that work successful? How did you achieving that goal make you feel?"
        firstDescriptionLabel.textAlignment = .center
        firstDescriptionLabel.numberOfLines = 0
        firstDescriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        firstDescriptionLabel.textColor = R.color.onboardings.backTitle()
        
        secondDescriptionLabel.text = "Keep these thoughts in mind as you navigate your health journey. You’ve done hard work before; you can \ndefinitely do it again!"
        secondDescriptionLabel.textAlignment = .center
        secondDescriptionLabel.numberOfLines = 0
        secondDescriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        secondDescriptionLabel.textColor = R.color.onboardings.backTitle()
        
        stackView.axis = .vertical
        stackView.spacing = 24
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(firstDescriptionLabel)
        stackView.addArrangedSubview(secondDescriptionLabel)
        
        view.addSubview(continueCommonButton)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(32)
            $0.right.equalTo(view.snp.right).offset(-32)
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)

        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton()
    }
}

// MARK: - ReflectToAchievedSomethingDifficultViewControllerInterface

extension ReflectToAchievedSomethingDifficultViewController: ReflectToAchievedSomethingDifficultViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}
