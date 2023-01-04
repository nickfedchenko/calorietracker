//
//  HealthAppViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 31.08.2022.
//

import Foundation
import UIKit

protocol HealthAppViewControllerInterface: AnyObject {}

class HealthAppViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: HealthAppPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    private let healthAppView: UIView = .init()
    private let healthAppImageView: UIImageView = .init()
    private let healthAppTitleLabel: UILabel = .init()
    private let healthAppDescriptionLabel: UILabel = .init()
    private let arrowImageView: UIImageView = .init()
    private let continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingFourthHealthAppButton().uppercased()
    )
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackBarButtonItem()
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()

        let attributedString = NSMutableAttributedString()
        
        scrolView.showsVerticalScrollIndicator = false

        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingFourthHealthAppTitleFirst(),
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
        ))
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingFourthHealthAppTitleSecond(),
            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 38, weight: .medium)
        
        // swiftlint:disable:next line_length
        descriptionLabel.text = R.string.localizable.onboardingFourthHealthAppDescription()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        descriptionLabel.textColor = R.color.onboardings.basicDarkGray()
        
        healthAppView.backgroundColor = .white
        
        healthAppImageView.image = UIImage(named: R.image.onboardings.healthApp.name)
        
        healthAppTitleLabel.text = R.string.localizable.onboardingFourthHealthAppTitleHealth()
        healthAppTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        healthAppTitleLabel.textColor = R.color.onboardings.basicDark()
        
        healthAppDescriptionLabel.text = R.string.localizable.onboardingFourthHealthAppDescriptionHealth()
        healthAppDescriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        healthAppDescriptionLabel.textColor = R.color.onboardings.basicDarkGray()
        
        arrowImageView.image = UIImage(named: R.image.onboardings.arrow.name)
        
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(descriptionLabel)
        
        contentView.addSubview(healthAppView)
        
        healthAppView.addSubview(healthAppImageView)
        healthAppView.addSubview(healthAppTitleLabel)
        healthAppView.addSubview(healthAppDescriptionLabel)
        healthAppView.addSubview(arrowImageView)
        
        contentView.addSubview(continueCommonButton)
        
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(30)
            $0.left.equalTo(contentView.snp.left).offset(42)
            $0.right.equalTo(contentView.snp.right).offset(-42)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.left.equalTo(contentView.snp.left).offset(42)
            $0.right.equalTo(contentView.snp.right).offset(-42)
        }
        
        healthAppView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(45)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
        }
        
        healthAppImageView.snp.makeConstraints {
            $0.top.equalTo(healthAppView.snp.top).offset(10)
            $0.left.equalTo(healthAppView.snp.left).offset(10)
            $0.bottom.equalTo(healthAppView.snp.bottom).offset(-10)
            $0.size.equalTo(70)
        }
        
        healthAppTitleLabel.snp.makeConstraints {
            $0.top.equalTo(healthAppView.snp.top).offset(18)
            $0.left.equalTo(healthAppImageView.snp.right).offset(10)
        }
        
        healthAppDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(healthAppTitleLabel.snp.bottom).offset(4)
            $0.left.equalTo(healthAppImageView.snp.right).offset(10)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.right.equalTo(healthAppView.snp.right).offset(-20)
            $0.centerY.equalTo(healthAppView.snp.centerY)
            $0.width.equalTo(15)
            $0.height.equalTo(16)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(healthAppView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton()
    }
}

// MARK: - HealthAppViewControllerInterface

extension HealthAppViewController: HealthAppViewControllerInterface {}
