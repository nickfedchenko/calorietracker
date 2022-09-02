//
//  CalorieCountViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import SnapKit
import UIKit

// swiftlint:disable line_length

protocol CalorieCountViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class CalorieCountViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: CalorieCountPresenterInterface?
    
    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let imagView: UIImageView = .init()
    private let approvalCommonButton: CommonButton = .init(style: .bordered, text: "Yes".uppercased())
    private let rejectionCommonButton: CommonButton = .init(style: .bordered, text: "No".uppercased())
    
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
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: "Have you ",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        attributedString.append(NSAttributedString(
            string: "counted calories ",
            attributes: [.foregroundColor:  R.color.onboardings.radialGradientFirst()]
        ))
        attributedString.append(NSAttributedString(
            string: "before??",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        
        imagView.image = R.image.onboardings.mainVidget()
        
        approvalCommonButton.addTarget(self, action: #selector(didTapApprovalCommonButton),
                                       for: .touchUpInside)
        
        rejectionCommonButton.addTarget(self, action: #selector(didTapRejectionCommonButton),
                                        for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(imagView)
        
        view.addSubview(approvalCommonButton)
        
        view.addSubview(rejectionCommonButton)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stageCounterView.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        imagView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(view.snp.left).offset(30)
            $0.right.equalTo(view.snp.right).offset(-30)
            $0.height.equalTo(204)
        }
        
        approvalCommonButton.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.height.equalTo(64)
        }
        
        rejectionCommonButton.snp.makeConstraints {
            $0.top.equalTo(approvalCommonButton.snp.bottom).offset(16)
            $0.left.equalTo(view.snp.left).offset(40)
            $0.right.equalTo(view.snp.right).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    @objc private func didTapApprovalCommonButton() {
        presenter?.didTapApprovalCommonButton()
    }
    
    @objc private func didTapRejectionCommonButton() {
        presenter?.didTapRejectionCommonButton()
    }
}

// MARK: - CalorieCountViewControllerInterface

extension CalorieCountViewController: CalorieCountViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}
