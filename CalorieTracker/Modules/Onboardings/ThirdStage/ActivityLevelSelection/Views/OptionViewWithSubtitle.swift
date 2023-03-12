//
//  OptionViewWithSubtitle.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 10.02.2023.
//

import UIKit


class AnswerOptionWithSubtitle: UIButton {
    
    // MARK: - Public properties
    
    override var isSelected: Bool {
        didSet { didChageIsSelected() }
    }
    
    var isTransparent: Bool = false {
        didSet { didChageIsTransparent() }
    }
    
    // MARK: - View properties
    
    private let titleLabel1: UILabel = .init()
    private let subtitleLabel1: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 14)
        label.textColor = UIColor(hex: "77928D")
        label.numberOfLines = 0
        return label
    }()
    
    private let checkMarkImageView: UIImageView = .init()

    // MARK: - Initialization
    
    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        
        titleLabel1.text = title
        subtitleLabel1.text = subtitle
        
        configureViews()
        configureLayouts()
        didChageIsSelected()
    }
    
    private func configureViews() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: R.color.onboardings.basicSecondaryDark.name)?.cgColor
        
        titleLabel1.font = R.font.sfProRoundedMedium(size: 16)
        titleLabel1.textColor = UIColor(hex: "192621")
        titleLabel1.numberOfLines = 0
        titleLabel1.textAlignment = .left
    }
    
    private func configureLayouts() {
        addSubview(titleLabel1)
        addSubview(subtitleLabel1)
        
        addSubview(checkMarkImageView)
        titleLabel1.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(16)
            $0.left.equalTo(snp.left).offset(20)
        }
        
        subtitleLabel1.snp.makeConstraints {
            $0.top.equalTo(titleLabel1.snp.bottom).offset(4)
            $0.left.equalTo(snp.left).offset(20)
            $0.bottom.equalTo(snp.bottom).offset(-16)
            $0.right.equalToSuperview().inset(50)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.left.equalTo(subtitleLabel1.snp.right).offset(5)
            $0.right.equalTo(snp.right).offset(-20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    private func didChageIsSelected() {
        if isSelected {
            backgroundColor = R.color.onboardings.radialGradientFirst()
            checkMarkImageView.image = R.image.onboardings.on()
            titleLabel1.textColor = .white
            subtitleLabel1.textColor = .white
        } else {
            backgroundColor = .clear
            checkMarkImageView.image = R.image.onboardings.off()
            titleLabel1.textColor = UIColor(hex: "192621")
            subtitleLabel1.textColor = UIColor(hex: "77928D")
        }
    }
    
    private func didChageIsTransparent() {
        alpha = isTransparent ? 0.5 : 1.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
