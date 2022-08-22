//
//  QuestionOfLosingWeightViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation
import UIKit
// swiftlint:disable all

protocol QuestionOfLosingWeightViewControllerInterface: AnyObject {}

final class QuestionOfLosingWeightViewController: UIViewController {
    
    // MARK: - Public properties
    
    var presenter: QuestionOfLosingWeightPresenterInterface?
    
    // MARK: - Views properties

    private let plugView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let approvalCommonButton: CommonButton = .init(style: .bordered, text: "Yes".uppercased())
    private let rejectionCommonButton: CommonButton = .init(style: .bordered, text: "No".uppercased())
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        view.backgroundColor = R.color.mainBackground()
        
        plugView.backgroundColor = R.color.onboardings.radialGradientFirst()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "Have you tried ", attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: "to lose weight befor?", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        
        approvalCommonButton.addTarget(self, action: #selector(didTapApprovalCommonButton),
                                       for: .touchUpInside)
        
        rejectionCommonButton.addTarget(self, action: #selector(didTapRejectionCommonButton),
                                        for: .touchUpInside)
    }
    
    private func configureLayouts() {
        view.addSubview(plugView)
        
        view.addSubview(titleLabel)
        
        view.addSubview(approvalCommonButton)
        
        view.addSubview(rejectionCommonButton)
        
        plugView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(view.snp.left).offset(100)
            $0.right.equalTo(view.snp.right).offset(-100)
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(view.snp.left).offset(43)
            $0.right.equalTo(view.snp.right).offset(-43)
            $0.centerY.equalTo(view.snp.centerY)
            $0.centerX.equalTo(view.snp.centerX)
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
        print("didTapApprovalCommonButton")
    }
    
    @objc private func didTapRejectionCommonButton() {
        print("didTapApprovalCommonButton")
    }
}

extension QuestionOfLosingWeightViewController: QuestionOfLosingWeightViewControllerInterface {}
