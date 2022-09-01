//
//  WhatImportantToYouViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 30.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable line_length

protocol WhatImportantToYouViewControllerInterface: AnyObject {}

final class WhatImportantToYouViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: WhatImportantToYouPresenterInterface?
    
    // MARK: - Views properties

    private let plugView: UIView = .init()
    private let stackView: UIStackView = .init()
    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let caloriesInMyFoodCommonButton: CommonButton = .init(style: .bordered, text: "The calories in my food".uppercased())
    private let nutritionOfMyFoodCommonButton: CommonButton = .init(style: .bordered, text: "The nutrition of my food".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        title = "Habits"
        
        view.backgroundColor = R.color.mainBackground()
        
        plugView.backgroundColor = R.color.onboardings.radialGradientFirst()
        
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.axis = .vertical
        
        imageView.image = UIImage(named: R.image.onboardings.vegan.name)
        
        titleLabel.text = "What is more important to you?"
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        caloriesInMyFoodCommonButton.addTarget(self, action: #selector(didTapCaloriesInMyFoodCommonButton),
                                       for: .touchUpInside)
        
        nutritionOfMyFoodCommonButton.addTarget(self, action: #selector(didTapNutritionOfMyFoodCommonButton),
                                        for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        view.addSubview(caloriesInMyFoodCommonButton)
        
        view.addSubview(nutritionOfMyFoodCommonButton)
        
        plugView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(view.snp.left).offset(100)
            $0.right.equalTo(view.snp.right).offset(-100)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
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

extension WhatImportantToYouViewController: WhatImportantToYouViewControllerInterface {}
