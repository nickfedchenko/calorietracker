//
//  LandingFinalCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingFinalCell: UICollectionViewCell {
    static let identifier = String(describing: LandingFinalCell.self)
    
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
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientLayer.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: FinalSectionModel) {
        mainTitle.text = model.titleString
        mainTitle.font = model.titleFont
        mainTitle.textColor = model.titleColor
        descriptionLabel.text = model.descriptionString
        descriptionLabel.font = model.descriptionFont
        descriptionLabel.textColor = model.descriptionColor
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.layer.addSublayer(gradientLayer)
        contentView.addSubviews(mainTitle, descriptionLabel)
        
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.greaterThanOrEqualToSuperview().inset(254)
        }
    }
}
