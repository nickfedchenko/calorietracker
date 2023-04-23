//
//  LandingTopSectionCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 19.04.2023.
//

import UIKit

final class LandingTopCell: UICollectionViewCell {
    static let identifier = String(describing: LandingTopCell.self)
    
    let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(hex: "0C695E").cgColor, UIColor(hex: "004139").cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 1)
        layer.endPoint = CGPoint(x: 0.5, y: 0)
        layer.locations = [0.5, 1]
        return layer
    }()
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientLayer.frame = bounds
    }
    
    func configure(with model: LandingTopSectionModel) {
        let font = model.commonTextFont
        mainTitle.textColor = .white
        let mainText = R.string.localizable.landingTopSectionTitleMainText()
        var replacedText = mainText.replacingOccurrences(of: "@weightTarget@", with: model.targetWeightString)
        replacedText = replacedText.replacingOccurrences(of: "@dateTarget@", with: model.targetDateString)
        
        mainTitle.colorString(
            text: replacedText,
            coloredText: [model.targetWeightString, model.targetDateString],
            color: .white,
            additionalAttributes: [.font: font ?? .systemFont(ofSize: 32), .foregroundColor: UIColor.white],
            coloredPartFont: model.targetsFont
        )
        
        descriptionLabel.text = model.descriptionText.replacingOccurrences(
            of: "@username@",
            with: UDM.userData?.name ?? ""
        )
        descriptionLabel.font = model.descriptionFont
        descriptionLabel.textColor = model.textColor
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.layer.addSublayer(gradientLayer)
        contentView.addSubviews(mainTitle, descriptionLabel)
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(87.fitH)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}

