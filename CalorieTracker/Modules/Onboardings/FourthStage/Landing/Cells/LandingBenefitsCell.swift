//
//  LandingBenefitsCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingBenefitsCell: UICollectionViewCell {
    static let identifier = String(describing: LandingBenefitsCell.self)
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let mainSubtitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: BenefitsSectionModel) {
        mainTitle.text = model.headerTitle
        mainTitle.font = model.headerFont
        mainTitle.textColor = model.headerTitleColor
        mainSubtitle.text = model.titleString
        mainSubtitle.font = model.titleFont
        mainSubtitle.textColor = model.titleColor
        mainImage.image = model.mainImage
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.addSubviews(mainTitle, mainSubtitle, mainImage)
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        mainSubtitle.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        mainImage.snp.makeConstraints { make in
            make.top.equalTo(mainSubtitle.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
}
