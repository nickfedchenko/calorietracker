//
//  PaywallViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import Foundation
import UIKit

protocol PaywallViewControllerInterface: AnyObject {}

final class PaywallViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: PaywallPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let subscriptionBenefitsContainerView: UIView = .init()
    private let convenientCalorieSubscriptionBenefits = SubscriptionBenefits(
        text: "Convenient calorie and activity tracker"
    )
    
    private let effectiveWeightSubscriptionBenefits = SubscriptionBenefits(
        text: "Effective weight loss or weight gain"
    )
    
    private let recipesForDifferentSubscriptionBenefits = SubscriptionBenefits(
        text: "10000+ recipes for different types of diets"
    )
    
    private let bestWaySubscriptionBenefits = SubscriptionBenefits(
        text: "The best way to keep your body in shape"
    )
    private let subscriptionAmount: SubscriptionAmount = .init()
    private let startNowCommonButton: CommonButton = .init(style: .filled, text: "Start now!")
    private let cancelAnytimeButton: CancelAnytime = .init()
    private let privacyPolicyButton: PrivacyPolicy = .init()
    private let termOfUseButton: TermOfUse = .init()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        scrolView.contentInsetAdjustmentBehavior = .never
        scrolView.showsVerticalScrollIndicator = false
        
        imageView.image = R.image.paywall.woman()
        
        titleLabel.text = "Losing weight has never been so easy!"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        
        subscriptionBenefitsContainerView.layer.cornerRadius = 20
        subscriptionBenefitsContainerView.backgroundColor = .white
        subscriptionBenefitsContainerView.layer.masksToBounds = false
        subscriptionBenefitsContainerView.layer.shadowColor = UIColor.black.cgColor
        subscriptionBenefitsContainerView.layer.shadowOpacity = 0.20
        subscriptionBenefitsContainerView.layer.shadowOffset = CGSize(width: 5, height: 5)
        subscriptionBenefitsContainerView.layer.shadowRadius = 5
        
        subscriptionAmount.addTarget(self, action: #selector(didTapSubscriptionAmount), for: .touchUpInside)
        
        startNowCommonButton.addTarget(self, action: #selector(didTapStartNow), for: .touchUpInside)
        
        cancelAnytimeButton.addTarget(self, action: #selector(didTapCancelAnytime), for: .touchUpInside)
        
        privacyPolicyButton.addTarget(self, action: #selector(didTapPrivacyPolicy), for: .touchUpInside)
        
        termOfUseButton.addTarget(self, action: #selector(didTapTermOfUse), for: .touchUpInside)
    }
    
    @objc func didTapSubscriptionAmount(_ sender: SubscriptionAmount) {
        if subscriptionAmount == sender {
            let isSelected = !subscriptionAmount.isSelected
                
            subscriptionAmount.isSelected = isSelected
                
        } else {
            subscriptionAmount.isSelected = false
        }
    }
    
    @objc private func didTapStartNow() {
        presenter?.didTapStartNow()
    }
    
    @objc private func didTapCancelAnytime() {
        presenter?.didTapCancelAnytime()
    }
    
    @objc private func didTapPrivacyPolicy() {
        presenter?.didTapPrivacyPolicy()
    }
    
    @objc private func didTapTermOfUse() {
        presenter?.didTapTermOfUse()
    }
    
    // swiftlint:disable:next function_body_length
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(subscriptionBenefitsContainerView)
        
        subscriptionBenefitsContainerView.addSubview(convenientCalorieSubscriptionBenefits)
        subscriptionBenefitsContainerView.addSubview(effectiveWeightSubscriptionBenefits)
        subscriptionBenefitsContainerView.addSubview(recipesForDifferentSubscriptionBenefits)
        subscriptionBenefitsContainerView.addSubview(bestWaySubscriptionBenefits)
        
        contentView.addSubview(subscriptionAmount)
        
        contentView.addSubview(startNowCommonButton)
        
        contentView.addSubview(cancelAnytimeButton)
        
        contentView.addSubview(privacyPolicyButton)
        
        contentView.addSubview(termOfUseButton)
        
        scrolView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
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
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.left.equalTo(contentView.snp.left)
            $0.right.equalTo(contentView.snp.right)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(24)
            $0.right.equalTo(contentView.snp.right).offset(-24)
            $0.bottom.equalTo(imageView.snp.bottom).offset(-60)
        }
        
        subscriptionBenefitsContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.left.equalTo(contentView.snp.left).offset(25)
            $0.right.equalTo(contentView.snp.right).offset(-25)
        }
        
        convenientCalorieSubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(subscriptionBenefitsContainerView.snp.top).offset(24)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left).offset(25)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right).offset(-25)
        }
        
        effectiveWeightSubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(convenientCalorieSubscriptionBenefits.snp.bottom).offset(24)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left).offset(25)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right).offset(-25)
        }
        
        recipesForDifferentSubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(effectiveWeightSubscriptionBenefits.snp.bottom).offset(24)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left).offset(25)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right).offset(-25)
        }
        
        bestWaySubscriptionBenefits.snp.makeConstraints {
            $0.top.equalTo(recipesForDifferentSubscriptionBenefits.snp.bottom).offset(24)
            $0.left.equalTo(subscriptionBenefitsContainerView.snp.left).offset(25)
            $0.right.equalTo(subscriptionBenefitsContainerView.snp.right).offset(-25)
            $0.bottom.equalTo(subscriptionBenefitsContainerView.snp.bottom).offset(-25)
        }
        
        subscriptionAmount.snp.makeConstraints {
            $0.top.equalTo(subscriptionBenefitsContainerView.snp.bottom).offset(28)
            $0.left.equalTo(contentView.snp.left).offset(28)
            $0.right.equalTo(contentView.snp.right).offset(-28)
            $0.size.equalTo(72)
        }
        
        startNowCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(subscriptionAmount.snp.bottom).offset(32)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.height.equalTo(64)
        }
        
        cancelAnytimeButton.snp.makeConstraints {
            $0.top.equalTo(startNowCommonButton.snp.bottom).offset(24)
            $0.centerX.equalTo(startNowCommonButton.snp.centerX)
        }
        
        privacyPolicyButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(cancelAnytimeButton.snp.bottom).offset(26)
            $0.left.equalTo(contentView.snp.left).offset(24)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
        }
        
        termOfUseButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(cancelAnytimeButton.snp.bottom).offset(26)
            $0.right.equalTo(contentView.snp.right).offset(-24)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension PaywallViewController: PaywallViewControllerInterface {}
