//
//  YoureNotAloneViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation
import UIKit

protocol YoureNotAloneViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class YoureNotAloneViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: YoureNotAlonePresenterInterface?
    
    // MARK: - Views properties

    private let stageCounterView: StageCounterView = .init()
    private let stackView: UIStackView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingFourthYoureNotAloneButton().uppercased()
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
        title = R.string.localizable.onboardingFourthYoureNotAloneTitle()
        
        view.backgroundColor = R.color.mainBackground()
    
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.axis = .vertical
        
        titleLabel.text = R.string.localizable.onboardingFourthYoureNotAloneTitleFirst()
        titleLabel.textColor = R.color.onboardings.radialGradientFirst()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        // swiftlint:disable:next line_length
        descriptionLabel.text = R.string.localizable.onboardingFourthYoureNotAloneDescription()
        descriptionLabel.textColor = R.color.onboardings.basicGray()
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton),
                                       for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        view.addSubview(continueCommonButton)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        stackView.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerY.equalTo(view.snp.centerY)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.snp.bottom).offset(-34)
            $0.height.equalTo(64)
        }
    }
    
    @objc private func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton()
    }
}

// MARK: - YoureNotAloneViewControllerInterface

extension YoureNotAloneViewController: YoureNotAloneViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}
