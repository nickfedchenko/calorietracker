//
//  AllergicRestrictionsViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation
import UIKit

protocol AllergicRestrictionsViewControllerInterface: AnyObject {
    func set(allergicRestrictions: [AllergicRestrictions])
    func set(currentOnboardingStage: OnboardingStage)
}

final class AllergicRestrictionsViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: AllergicRestrictionsPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private var variabilityResponses: [VariabilityResponse] = []
    private let continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingSecondAllergicRestrictionsButton().uppercased()
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
        view.backgroundColor = R.color.mainBackground()
        
        titleLabel.text = R.string.localizable.onboardingSecondAllergicRestrictionsTitle()
        titleLabel.textColor = R.color.onboardings.basicDark()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        continueCommonButton.isHidden = true
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(stackView)
        
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
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(contentView.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(43)
            $0.right.equalTo(contentView.snp.right).offset(-43)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(44)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapVariabilityResponse(_ sender: VariabilityResponse) {
        presenter?.restrictionTapped(at: sender.tag)
        variabilityResponses.forEach { variabilityResponses in
            if variabilityResponses == sender {
                let isSelected = !variabilityResponses.isSelected
                variabilityResponses.isSelected = isSelected
            }
        }
        
        continueCommonButton.isHidden = !variabilityResponses.contains(where: { $0.isSelected == true })
    }
    
    @objc func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton()
    }
}

// MARK: - AllergicRestrictionsViewControllerInterface

extension AllergicRestrictionsViewController: AllergicRestrictionsViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
    
    func set(allergicRestrictions: [AllergicRestrictions]) {
        stackView.removeAllArrangedSubviews()
        variabilityResponses = []
        
        for (i, allergicRestrictions) in allergicRestrictions.enumerated() {
            let variabilityResponse = VariabilityResponse()
            variabilityResponse.tag = i
            variabilityResponse.title = allergicRestrictions.description
            
            variabilityResponse.addTarget(self, action: #selector(didTapVariabilityResponse), for: .touchUpInside)
            
            stackView.addArrangedSubview(variabilityResponse)
            variabilityResponses.append(variabilityResponse)
        }
    }
}
