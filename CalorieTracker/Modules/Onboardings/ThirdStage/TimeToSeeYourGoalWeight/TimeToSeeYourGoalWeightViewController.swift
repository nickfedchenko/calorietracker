//
//  TimeToSeeYourGoalWeightViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 29.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable line_length

protocol TimeToSeeYourGoalWeightViewControllerInterface: AnyObject {}

final class TimeToSeeYourGoalWeightViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: TimeToSeeYourGoalWeightPresenterInterface?
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let stackView: UIStackView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let setGoalWeightCommonButton: CommonButton = .init(style: .filled, text: "Continue".uppercased())
    
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
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: "It’s time to see your ",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        
        attributedString.append(NSAttributedString(
            string: "goal weight",
            attributes: [.foregroundColor:  R.color.onboardings.radialGradientFirst()]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        descriptionLabel.text = "Some people prefer to start with a smaller goal, while others prefer to keep the focus on their long term goal. \nDo whichever feels best to you!"
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = R.color.onboardings.backTitle()
        
        stackView.axis = .vertical
        stackView.spacing = 24
        
        setGoalWeightCommonButton.addTarget(self, action: #selector(didTapSetGoalWeightCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        view.addSubview(setGoalWeightCommonButton)
        
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
        
        setGoalWeightCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapSetGoalWeightCommonButton() {
        presenter?.didTapSetGoalWeightCommonButton()
    }
}

// MARK: - TimeToSeeYourGoalWeightViewControllerInterface

extension TimeToSeeYourGoalWeightViewController: TimeToSeeYourGoalWeightViewControllerInterface {}
