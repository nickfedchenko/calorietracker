//
//  SubscriptionBenefits.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import Foundation
import UIKit

final class SubscriptionBenefits: UIView {
    
    // MARK: - Private properties
    
    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    
    // MARK: - Initialization
    
    init(text: String) {
        
        super.init(frame: .zero)
        
        titleLabel.text = text
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        backgroundColor = .clear
        
        imageView.image = R.image.onboardings.on()
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
    }
    
    private func configureLayouts() {
        addSubview(imageView)
        
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.left.equalTo(snp.left)
            $0.bottom.equalTo(snp.bottom)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.left.equalTo(imageView.snp.right).offset(12)
            $0.right.equalTo(snp.right)
            $0.bottom.equalTo(snp.bottom)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
