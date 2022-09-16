//
//  VariabilityResponse.swift
//  CalorieTracker
//
//  Created by Алексей on 25.08.2022.
//

import UIKit

class VariabilityResponse: UIButton {
    
    // MARK: - Public properties
    
    override var isSelected: Bool {
        didSet { didChageIsSelected() }
    }
    
    var isTransparent: Bool = false {
        didSet { didChageIsTransparent() }
    }
    
    var image: UIImage? {
        get {
            return leftImageView.image
        }
        set {
            leftImageView.isHidden = newValue == nil
            leftImageView.image = newValue
        }
    }
    
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
    
    // MARK: - View properties
    
    private let stackView: UIStackView = .init()
    private let leftImageView: UIImageView = .init()
    private let verticalStackView: UIStackView = .init()
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
        backgroundColor = .white
        
        layer.borderColor = UIColor(named: R.color.onboardings.radialGradientFirst.name)?.cgColor

        layer.cornerRadius = 16
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = 8
        
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.isUserInteractionEnabled = false
        
        leftImageView.isHidden = true
        
        verticalStackView.axis = .vertical
        stackView.spacing = 0
        
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLabel.isHidden = true
        
        describeLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        describeLabel.isHidden = true
        describeLabel.textColor = R.color.onboardings.basicGray()
    }
    
    private func configureLayouts() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(leftImageView)
        stackView.addArrangedSubview(verticalStackView)
        stackView.addArrangedSubview(checkMarkImageView)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(describeLabel)
                
        stackView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(20)
            $0.left.equalTo(snp.left).offset(16)
            $0.right.equalTo(snp.right).offset(-16)
            $0.bottom.equalTo(snp.bottom).offset(-20)
        }
        
        leftImageView.snp.makeConstraints {
            $0.size.equalTo(34)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    private func didChageIsSelected() {
        if isSelected {
            layer.borderWidth = 1
            checkMarkImageView.image = R.image.onboardings.checkOk()
        } else {
            layer.borderWidth = 0
            checkMarkImageView.image = R.image.onboardings.off()
        }
    }
    
    private func didChageIsTransparent() {
        alpha = isTransparent ? 0.5 : 1.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
