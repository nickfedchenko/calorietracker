//
//  LandingWaterCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingWaterCell: UICollectionViewCell {
    static let identifier = String(describing: LandingWaterCell.self)
    
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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: WaterSectionModel) {
        mainTitle.text = model.headerTitle
        mainTitle.font = model.headerFont
        mainTitle.textColor = model.headerTitleColor
        
        mainSubtitle.attributedText = model.titleString

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
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(mainTitle.snp.bottom).offset(12)
        }
        
        mainImage.snp.makeConstraints { make in
            make.top.equalTo(mainSubtitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
