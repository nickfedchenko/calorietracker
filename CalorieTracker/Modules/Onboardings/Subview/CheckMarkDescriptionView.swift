//
//  CheckMarkDescriptionView.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import SnapKit
import UIKit

final class CheckMarkDescriptionView: UIView {
    
    // MARK: - Views properties
    
    private let checkMarkImageView: UIImageView = .init()
    private let descriptionLabel: UILabel = .init()
    
    // MARK: - Initialization
    
    init(text: String) {
        super.init(frame: .zero)
        
        descriptionLabel.text = text
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        checkMarkImageView.image = R.image.onboardings.chekmark()
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        descriptionLabel.textColor = R.color.onboardings.basicDark()
    }
    
    private func configureLayouts() {
        addSubview(checkMarkImageView)
        addSubview(descriptionLabel)
        
        checkMarkImageView.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.left.equalTo(snp.left)
            $0.bottom.equalTo(snp.bottom)
            $0.size.equalTo(33)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.right.equalTo(snp.right)
            $0.left.equalTo(checkMarkImageView.snp.right).offset(8)
            $0.centerY.equalTo(checkMarkImageView.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
