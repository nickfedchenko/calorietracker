//
//  AnswerOption.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation
import UIKit

class AnswerOption: UIButton {
    
    // MARK: - Public properties
    
    override var isSelected: Bool {
        didSet { didChageIsSelected() }
    }
    
    var isTransparent: Bool = false {
        didSet { didChageIsTransparent() }
    }
    
    // MARK: - View properties
    
    private let titleLabel1: UILabel = .init()
    private let checkMarkImageView: UIImageView = .init()

    // MARK: - Initialization
    
    init(text: String) {
        super.init(frame: .zero)
        
        titleLabel1.text = text
        
        configureViews()
        configureLayouts()
        didChageIsSelected()
    }
    
    private func configureViews() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: R.color.onboardings.basicSecondaryDark.name)?.cgColor
        
        titleLabel1.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel1.numberOfLines = 0
        titleLabel1.textAlignment = .left
    }
    
    private func configureLayouts() {
        addSubview(titleLabel1)
        
        addSubview(checkMarkImageView)
        
        titleLabel1.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(20)
            $0.left.equalTo(snp.left).offset(20)
            $0.bottom.equalTo(snp.bottom).offset(-20)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.left.equalTo(titleLabel1.snp.right).offset(5)
            $0.right.equalTo(snp.right).offset(-20)
            $0.centerY.equalTo(titleLabel1.snp.centerY)
            $0.size.equalTo(24)
        }
    }
    
    private func didChageIsSelected() {
        if isSelected {
            backgroundColor = R.color.onboardings.radialGradientFirst()
            checkMarkImageView.image = R.image.onboardings.on()
            titleLabel1.textColor = .white
        } else {
            backgroundColor = .clear
            checkMarkImageView.image = R.image.onboardings.off()
            titleLabel1.textColor = R.color.onboardings.basicDark()
        }
    }
    
    private func didChageIsTransparent() {
        alpha = isTransparent ? 0.5 : 1.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
