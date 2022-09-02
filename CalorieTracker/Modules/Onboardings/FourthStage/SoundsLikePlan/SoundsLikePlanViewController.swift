//
//  SoundsLikePlanViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable line_length

protocol SoundsLikePlanViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class SoundsLikePlanViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: SoundsLikePlanPresenterInterface?
    
    // MARK: - Views properties

    private let stageCounterView: StageCounterView = .init()
    private let stackView: UIStackView = .init()
    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
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
        title = "Habits"
        
        view.backgroundColor = R.color.mainBackground()
        
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.axis = .vertical
        
        imageView.image = UIImage(named: R.image.onboardings.vegan.name)
        
        titleLabel.text = "Sounds like a plan!"
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        descriptionLabel.text = "Making smart food decisions is a big part of weight loss. Just don’t do anything to lose the weight that you won’t do to keep it off!"
        descriptionLabel.textColor = R.color.onboardings.basicGray()
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
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
            $0.top.equalTo(stageCounterView.snp.bottom).offset(80)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(96)
        }
        
        continueCommonButton.snp.makeConstraints {
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

// MARK: - SoundsLikePlanViewControllerInterface

extension SoundsLikePlanViewController: SoundsLikePlanViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}
