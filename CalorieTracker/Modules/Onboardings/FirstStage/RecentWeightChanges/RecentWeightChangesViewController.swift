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
    
    private let scrolView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stageCounterView: StageCounterView = .init()
    private let titleLabel: UILabel = .init()
    private let approvalCommonButton: CommonButton = .init(
        style: .bordered,
        text: R.string.localizable.onboardingFirstRecentWeightChangesApproval().uppercased()
    )
    private let rejectionCommonButton: CommonButton = .init(
        style: .bordered,
        text: R.string.localizable.onboardingFirstRecentWeightChangesRejection().uppercased()
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
        title = R.string.localizable.onboardingFirstRecentWeightChangesTitle()
        
        view.backgroundColor = R.color.mainBackground()
        
        scrolView.showsVerticalScrollIndicator = false
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingFirstRecentWeightChangesTitleFirst(),
            attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()!]
        ))
        
        attributedString.append(.init(string: " "))
        
        attributedString.append(NSAttributedString(
            string: R.string.localizable.onboardingFirstRecentWeightChangesTitleSecond(),
            attributes: [.foregroundColor: R.color.onboardings.basicDark()!]
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
        view.addSubview(scrolView)
        
        scrolView.addSubview(contentView)
        
        contentView.addSubview(stageCounterView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(approvalCommonButton)
        
        contentView.addSubview(rejectionCommonButton)
        
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
            $0.left.equalTo(contentView.snp.left).offset(43)
            $0.right.equalTo(contentView.snp.right).offset(-43)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        approvalCommonButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.height.equalTo(64)
        }
        
        rejectionCommonButton.snp.makeConstraints {
            $0.top.equalTo(approvalCommonButton.snp.bottom).offset(16)
            $0.left.equalTo(contentView.snp.left).offset(40)
            $0.right.equalTo(contentView.snp.right).offset(-40)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-35)
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
