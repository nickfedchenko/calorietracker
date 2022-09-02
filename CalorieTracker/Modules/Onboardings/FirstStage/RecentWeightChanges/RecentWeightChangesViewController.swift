//
//  RecentWeightChangesViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import SnapKit
import UIKit

protocol RecentWeightChangesViewControllerInterface: AnyObject {
    func set(currentOnboardingStage: OnboardingStage)
}

final class RecentWeightChangesViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: RecentWeightChangesPresenterInterface?

    // MARK: - Views properties
    
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
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
            string: "Think back to when\n you last worked on\n your weight. ",
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]
        ))
        attributedString.append(NSAttributedString(
            string: "Is \nanything different \nabout this time than \nlast time?",
            attributes: [.foregroundColor: R.color.onboardings.basicDark()]
        ))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        
        approvalCommonButton.addTarget(self, action: #selector(didTapApprovalCommonButton),
                                       for: .touchUpInside)
        
        rejectionCommonButton.addTarget(self, action: #selector(didTapRejectionCommonButton),
                                        for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(stageCounterView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(approvalCommonButton)
        
        view.addSubview(rejectionCommonButton)
        
        stageCounterView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
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

// MARK: - RecentWeightChangesViewControllerInterface

extension RecentWeightChangesViewController: RecentWeightChangesViewControllerInterface {
    func set(currentOnboardingStage: OnboardingStage) {
        stageCounterView.set(onboardingStage: currentOnboardingStage)
    }
}
