//
//  LandingCirclesCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingCirclesCell: UICollectionViewCell {
    static let identifier = String(describing: LandingCirclesCell.self)
    
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
    
    private let circlesImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let bjuStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientLayer.frame = contentView.bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bjuStack.removeAllArrangedSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    func configure(with model: CirclesSectionModel) {
        mainTitle.text = model.titleString
        mainTitle.font = model.titleFont
        mainTitle.textColor = .white
        circlesImageView.image = model.circlesImage
        
        // kcal label
        let kcalLabel = UILabel()
        kcalLabel.font = R.font.sfProRoundedBold(size: 18)
        kcalLabel.textAlignment = .left
        kcalLabel.textColor = model.kcalLabelColor
        kcalLabel.text = model.kcalGoal
        
        // carbs label
        let carbsLabel = UILabel()
        carbsLabel.font = R.font.sfProRoundedBold(size: 18)
        carbsLabel.textAlignment = .left
        carbsLabel.textColor = model.carbsLabelColor
        carbsLabel.text = model.carbsGoal
        
        // protein label
        let proteinLabel = UILabel()
        proteinLabel.font = R.font.sfProRoundedBold(size: 18)
        proteinLabel.textAlignment = .left
        proteinLabel.textColor = model.proteinLabelColor
        proteinLabel.text = model.proteinGoal
        
        // protein label
        let fatsLabel = UILabel()
        fatsLabel.font = R.font.sfProRoundedBold(size: 18)
        fatsLabel.textAlignment = .left
        fatsLabel.textColor = model.fatsLabelColor
        fatsLabel.text = model.fatsGoal
        bjuStack.addArrangedSubviews(kcalLabel, carbsLabel, proteinLabel, fatsLabel)
        
        descriptionLabel.attributedText = model.descriptionText
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.layer.addSublayer(gradientLayer)
        contentView.addSubviews(mainTitle, descriptionLabel, circlesImageView, bjuStack)
        
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        
        circlesImageView.snp.makeConstraints { make in
            make.width.height.equalTo(134)
            make.top.equalTo(mainTitle.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(40)
        }
        
        bjuStack.snp.makeConstraints { make in
            make.top.equalTo(circlesImageView)
            make.leading.equalTo(circlesImageView.snp.trailing).offset(24)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(circlesImageView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
