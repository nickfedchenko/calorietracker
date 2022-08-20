//
//  BackButton.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation
import UIKit

class BackButton: UIView {
    
    // MARK: - Views properties
    
    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        backgroundColor = .clear
     
        imageView.image = R.image.onboardings.arrow()
        
        titleLabel.text = "Back"
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = R.color.onboardings.basicDarkGray()
    }
    
    private func configureLayouts() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.left.equalTo(snp.left)
            $0.bottom.equalTo(snp.bottom)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(imageView.snp.right).offset(6)
            $0.right.equalTo(snp.right)
            $0.centerY.equalTo(imageView.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
