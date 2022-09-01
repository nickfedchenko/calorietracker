//
//  RisksOfDiseasesViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 28.08.2022.
//

import Foundation
import UIKit

// swiftlint:disable line_length

protocol RisksOfDiseasesViewControllerInterface: AnyObject {
    func set(risksOfDiseases: [RisksOfDiseases])
    func set(currentOnboardingStage: OnboardingStage)
}

final class RisksOfDiseasesViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: RisksOfDiseasesPresenterInterface?
    
    // MARK: - Views properties
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private var variabilityResponses: [VariabilityResponse] = []
    private let continueCommonButton: CommonButton = .init(style: .filled, text: "continue".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: "Are you at risk for any of the following ",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        attributedString.append(NSAttributedString(
            string: "diseases?",
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]
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
        variabilityResponses.enumerated().forEach { index, variabilityResponses in
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

// MARK: - RisksOfDiseasesViewControllerInterface

extension RisksOfDiseasesViewController: RisksOfDiseasesViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
    
    func set(risksOfDiseases: [RisksOfDiseases]) {
        stackView.removeAllArrangedSubviews()
        variabilityResponses = []
        
        for risksOfDiseases in risksOfDiseases {
            let variabilityResponse = VariabilityResponse()
            
            variabilityResponse.title = risksOfDiseases.description
            
            variabilityResponse.addTarget(self, action: #selector(didTapVariabilityResponse), for: .touchUpInside)
            
            stackView.addArrangedSubview(variabilityResponse)
            variabilityResponses.append(variabilityResponse)
        }
    }
}

// MARK: - RisksOfDiseases + description

fileprivate extension RisksOfDiseases {
    var description: String {
        switch self {
        case .highBloodPressure:
            return "High blood pressure"
        case .heartDiseaseOrStroke:
            return "Heart disease or stroke)"
        case .diabetes:
            return "Diabetes"
        case .osteoarthritis:
            return "Osteoarthritis"
        case .kidneyDisease:
            return "Kidney disease"
        case .depression:
            return "Depression"
        case .noneOfThese:
            return "None of these"
        }
    }
}
