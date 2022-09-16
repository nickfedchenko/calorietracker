//
//  SubscriptionAmount.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import Foundation
import UIKit

final class SubscriptionAmount: UIButton {
    
    // MARK: - Public properties
    
    var title: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.isHidden = newValue == nil
            nameLabel.text = newValue
        }
    }
    
    var describe: String? {
        get {
            return describeLabel.text
        }
        set {
            describeLabel.isHidden = newValue == nil
            describeLabel.text = newValue
        }
    }
    
    override var isSelected: Bool {
        didSet { didChageIsSelected() }
    }
    
    // MARK: - View properties
    
    private let stackView: UIStackView = .init()
    private let nameLabel: UILabel = .init()
    private let describeLabel: UILabel = .init()
    private let checkMarkImageView: UIImageView = .init()

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayouts()
        didChageIsSelected()
    }
    
    private func configureViews() {
        backgroundColor = R.color.mainBackground()
        
        layer.borderColor = UIColor(named: R.color.onboardings.radialGradientFirst.name)?.cgColor

        layer.cornerRadius = 16
        layer.borderWidth = 2
        
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.text = "Annually — $24.40 (3 days free)"
        
        describeLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        describeLabel.textColor = R.color.onboardings.basicGray()
        describeLabel.text = "$0,46 — week / 3 days free"
    }
    
    private func configureLayouts() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(describeLabel)
        
        addSubview(checkMarkImageView)
                
        stackView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(15)
            $0.left.equalTo(snp.left).offset(20)
            $0.bottom.equalTo(snp.bottom).offset(-15)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.left.equalTo(stackView.snp.right).offset(16)
            $0.right.equalTo(snp.right).offset(-16)
            $0.centerY.equalTo(stackView.snp.centerY)
            $0.size.equalTo(24)
        }
    }
    
    private func didChageIsSelected() {
        if isSelected {
            layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
            checkMarkImageView.image = R.image.onboardings.complet()
        } else {
            layer.borderColor = R.color.onboardings.basicGray()?.cgColor
            checkMarkImageView.image = R.image.paywall.dottedLine()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
