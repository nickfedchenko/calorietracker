//
//  PresenceOfAllergiesViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation
import UIKit

protocol PresenceOfAllergiesViewControllerInterface: AnyObject {
    func set(presenceOfAllergies: [PresenceOfAllergies])
    func set(currentOnboardingStage: OnboardingStage)
}

final class PresenceOfAllergiesViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: PresenceOfAllergiesPresenterInterface?
    
    // MARK: - Private properties
    
    var isHedden: Bool = false {
        didSet { didChangeIsHeaden() }
    }
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private var variabilityResponses: [VariabilityResponse] = []
    private let continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingSecondPresenceOfAllergiesButton().uppercased()
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
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingSecondPresenceOfAllergiesTitleFirst(),
            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
        ))
        
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingSecondPresenceOfAllergiesTitleSecond(),
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
        ))
        
        attributedString.append(.init(string: " "))
        
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingSecondPresenceOfAllergiesTitleThird(),
            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        continueCommonButton.isHidden = true
        continueCommonButton.addTarget(self, action: #selector(didTapContinueCommonButton), for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(stackView)
        
        view.addSubview(continueCommonButton)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
        }
        
        continueCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc func didTapVariabilityResponse(_ sender: VariabilityResponse) {
        variabilityResponses.enumerated().forEach { index, variabilityResponses in
            if variabilityResponses == sender {
                let isSelected = !variabilityResponses.isSelected
                
                variabilityResponses.isSelected = isSelected
                
                if isSelected {
                    presenter?.didSelectPresenceOfAllergies(with: index)
                } else {
                    presenter?.didDeselectPresenceOfAllergies()
                }
            } else {
                variabilityResponses.isSelected = false
            }
        }
        
        continueCommonButton.isHidden = !variabilityResponses.contains(where: { $0.isSelected == true })
    }
    
    @objc func didTapContinueCommonButton() {
        presenter?.didTapContinueCommonButton()
    }
    
    private func didChangeIsHeaden() {
        if isHedden {
            continueCommonButton.isHidden = false
        } else {
            continueCommonButton.isHidden = true
        }
    }
}

// MARK: - PresenceOfAllergiesViewControllerInterface

extension PresenceOfAllergiesViewController: PresenceOfAllergiesViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
    
    func set(presenceOfAllergies: [PresenceOfAllergies]) {
        stackView.removeAllArrangedSubviews()
        variabilityResponses = []
        
        for presenceOfAllergies in presenceOfAllergies {
            let variabilityResponse = VariabilityResponse()
            
            variabilityResponse.title = presenceOfAllergies.description
            
            variabilityResponse.addTarget(self, action: #selector(didTapVariabilityResponse), for: .touchUpInside)
            
            stackView.addArrangedSubview(variabilityResponse)
            variabilityResponses.append(variabilityResponse)
        }
    }
}

// MARK: - PresenceOfAllergies + description

fileprivate extension PresenceOfAllergies {
    var description: String {
        switch self {
        case .yes:
            return R.string.localizable.onboardingSecondPresenceOfAllergiesDescriptionYes()
        case .no:
            return R.string.localizable.onboardingSecondPresenceOfAllergiesDescriptionNo()
        }
    }
}
