//
//  QuestionOfLosingWeightView.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import SnapKit
import UIKit
// swiftlint:disable all

final class QuestionOfLosingWeightView: UIView {
    
    // MARK: - Views properties

    private let plugView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let approvalCommonButton: CommonButton = .init(style: .bordered, text: "Yes".uppercased())
    private let rejectionCommonButton: CommonButton = .init(style: .bordered, text: "No".uppercased())
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        backgroundColor = .white
        
        plugView.backgroundColor = R.color.onboardings.radialGradientFirst()
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: "Have you tried ", attributes: [.foregroundColor: R.color.onboardings.radialGradientFirst()]))
        attributedString.append(NSAttributedString(string: "to lose weight befor?", attributes: [.foregroundColor: R.color.onboardings.basicDark()]))
        
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
    }
    
    private func configureLayouts() {
        addSubview(plugView)
        
        addSubview(titleLabel)
        
        addSubview(approvalCommonButton)
        
        addSubview(rejectionCommonButton)
        
        plugView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            $0.left.equalTo(snp.left).offset(100)
            $0.right.equalTo(snp.right).offset(-100)
            $0.centerX.equalTo(snp.centerX)
            $0.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(43)
            $0.right.equalTo(snp.right).offset(-43)
            $0.centerY.equalTo(snp.centerY)
            $0.centerX.equalTo(snp.centerX)
        }
        
        approvalCommonButton.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(40)
            $0.right.equalTo(snp.right).offset(-40)
            $0.height.equalTo(64)
        }
        
        rejectionCommonButton.snp.makeConstraints {
            $0.top.equalTo(approvalCommonButton.snp.bottom).offset(16)
            $0.left.equalTo(snp.left).offset(40)
            $0.right.equalTo(snp.right).offset(-40)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-35)
            $0.height.equalTo(64)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
