//
//  ThanksForTheInformationViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 23.08.2022.
//

import Foundation
import UIKit

protocol ThanksForTheInformationViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class ThanksForTheInformationViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: ThanksForTheInformationPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let imageView: UIImageView = .init()
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
        title = "History"
        
        view.backgroundColor = R.color.mainBackground()
        
        scrolView.showsVerticalScrollIndicator = false
        
        let attributedString = NSMutableAttributedString()

        attributedString.append(NSAttributedString(
            string: "Thanks ",
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]
        ))
        
        attributedString.append(NSAttributedString(
            string: "for the information!",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        imageView.image = R.image.onboardings.picThkYouPageScreen()
        
        // swiftlint:disable:next line_length
        descriptionLabel.text = "We know that losing weight can be difficult. Remember, it's not about the numbers on the scale, it's about becoming a better and healthier version of yourself."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = R.color.onboardings.backTitle()
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        view.addSubview(stageCounterView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(imageView)
        
        view.addSubview(descriptionLabel)
        
        view.addSubview(continueCommonButton)
        
        scrolView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrolView.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(scrolView.snp.bottom)
            $0.height.greaterThanOrEqualTo(scrolView.snp.height)
        }
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(43)
            $0.right.equalTo(contentView.snp.right).offset(-43)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.height.equalTo(190)
            $0.width.equalTo(230)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(43)
            $0.right.equalTo(contentView.snp.right).offset(-43)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapContinueCommonButton(_ sender: AnswerOption) {
        presenter?.didTapContinueCommonButton()
    }
}

// MARK: - ThanksForTheInformationViewControllerInterface

extension ThanksForTheInformationViewController: ThanksForTheInformationViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}