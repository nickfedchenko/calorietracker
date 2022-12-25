//
//  WhatImportantToYouViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation
import UIKit

protocol WhatImportantToYouViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class WhatImportantToYouViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: WhatImportantToYouPresenterInterface?
    
    // MARK: - Views properties

    private let stageCounterView: StageCounterView = .init()
    private let stackView: UIStackView = .init()
    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let caloriesInMyFoodCommonButton = CommonButton(
        style: .bordered,
        text: R.string.localizable.onboardingFourthWhatImportantToYouButtonCalorie().uppercased()
    )
    private let nutritionOfMyFoodCommonButton = CommonButton(
        style: .bordered,
        text: R.string.localizable.onboardingFourthWhatImportantToYouButtonNutrition().uppercased()
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
        title = R.string.localizable.onboardingFourthWhatImportantToYouTitle()
        
        view.backgroundColor = R.color.mainBackground()
        
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.axis = .vertical
        
        imageView.image = UIImage(named: R.image.onboardings.vegan.name)
        
        titleLabel.text = R.string.localizable.onboardingFourthWhatImportantToYouTitleFirst()
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        caloriesInMyFoodCommonButton.addTarget(
            self,
            action: #selector(didTapCaloriesInMyFoodCommonButton),
            for: .touchUpInside
        )
        
        nutritionOfMyFoodCommonButton.addTarget(
            self,
            action: #selector(didTapNutritionOfMyFoodCommonButton),
            for: .touchUpInside
        )
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        view.addSubview(caloriesInMyFoodCommonButton)
        
        view.addSubview(nutritionOfMyFoodCommonButton)
        
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
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(96)
        }
        
        caloriesInMyFoodCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.height.equalTo(64)
        }
        
        nutritionOfMyFoodCommonButton.snp.makeConstraints {
            $0.top.equalTo(caloriesInMyFoodCommonButton.snp.bottom).offset(16)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc private func didTapCaloriesInMyFoodCommonButton() {
        presenter?.didTapCaloriesInMyFoodCommonButton()
    }
    
    @objc private func didTapNutritionOfMyFoodCommonButton() {
        presenter?.didTapNutritionOfMyFoodCommonButton()
    }
}

// MARK: - WhatImportantToYouViewControllerInterface

extension WhatImportantToYouViewController: WhatImportantToYouViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}
