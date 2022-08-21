//
//  AnswerOption.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation
import UIKit

class AnswerOption: UIView {
    
    // MARK: - Private properties
    
    var isSelected: Bool = false {
        didSet { didChageIsSelected() }
    }
    
    // MARK: - View properties

    private let titleLabel: UILabel = .init()
    private let checkMarkImageView: UIImageView = .init()

    // MARK: - Initialization
    
    init(text: String) {
        super.init(frame: .zero)
        
        titleLabel.text = text
        
        configureViews()
        configureLayouts()
        didChageIsSelected()
    }
    
    private func configureViews() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: R.color.onboardings.basicSecondaryDark.name)?.cgColor
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    private func configureLayouts() {
        addSubview(titleLabel)
        
        addSubview(checkMarkImageView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(20)
            $0.left.equalTo(snp.left).offset(20)
            $0.bottom.equalTo(snp.bottom).offset(-20)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.right.equalTo(snp.right).offset(-20)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
    
    private func didChageIsSelected() {
        if isSelected {
            backgroundColor = R.color.onboardings.radialGradientFirst()
            checkMarkImageView.image = R.image.onboardings.on()
            titleLabel.textColor = .white
        } else {
            backgroundColor = .clear
            checkMarkImageView.image = R.image.onboardings.off()
            titleLabel.textColor = R.color.onboardings.basicDark()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
