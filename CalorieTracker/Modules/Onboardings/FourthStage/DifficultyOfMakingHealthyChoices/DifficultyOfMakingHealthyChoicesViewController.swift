//
//  DifficultyOfMakingHealthyChoicesViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable line_length

protocol DifficultyOfMakingHealthyChoicesViewControllerInterface: AnyObject {}

final class DifficultyOfMakingHealthyChoicesViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: DifficultyOfMakingHealthyChoicesPresenterInterface?
    
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
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "Motivation/Goal"
        
        view.backgroundColor = R.color.mainBackground()
        
        titleLabel.text = "It is hard to make healthy choices when the people around you are not."
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        firstDescriptionLabel.text = "Try to be aware of these moments, and break the mold of mirroring the behavior of other people. you are in charge of your own behavior."
        firstDescriptionLabel.textAlignment = .center
        firstDescriptionLabel.numberOfLines = 0
        firstDescriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        firstDescriptionLabel.textColor = R.color.onboardings.backTitle()
        
        secondDescriptionLabel.text = "You may besurprised at the effect it has on those around you!"
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
            $0.height.equalTo(30)
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

// MARK: - DifficultyOfMakingHealthyChoicesViewControllerInterface

extension DifficultyOfMakingHealthyChoicesViewController: DifficultyOfMakingHealthyChoicesViewControllerInterface {}
