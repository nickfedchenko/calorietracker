//
//  FoodCellView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.11.2022.
//

import UIKit

final class FoodCellView: UIView {
    struct FoodViewModel {
        let id: Int
        let title: String
        let description: String
        let tag: String
        let kcal: Int
        let flag: Bool
        let image: UIImage?
        let subInfo: Int?
        let color: UIColor?
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var addImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.addFood.recipesCell.add()
        return view
    }()
    
    private lazy var checkImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.addFood.recipesCell.cheked()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 15)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 15)
        label.textColor = R.color.addFood.recipesCell.basicGray()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 15)
        label.textColor = .white
        return label
    }()
    
    private lazy var tagBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 5
        view.backgroundColor = R.color.addFood.recipesCell.basicGray()
        return view
    }()
    
    private lazy var kalorieLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplayBold(size: 15)
        label.textColor = R.color.addFood.menu.kcal()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplayBold(size: 15)
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: FoodViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        tagLabel.text = model.tag
        kalorieLabel.text = "\(model.kcal)"
        imageView.image = model.image
        
        infoLabel.textColor = model.color
        if let info = model.subInfo {
            infoLabel.text = "\(info)"
        }
    }
    
    private func setupView() {
        
    }
    
    private func addSubviews() {
        tagBackgroundView.addSubview(tagLabel)
        
        addSubviews(
            imageView,
            addImageView,
            checkImageView,
            titleLabel,
            descriptionLabel,
            kalorieLabel,
            infoLabel,
            tagBackgroundView
        )
    }
    
    private func setupConstraints() {
        imageView.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(4)
            make.top.equalToSuperview().offset(4)
        }
        
        tagBackgroundView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(4)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-7)
        }
        
        tagLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        tagLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        checkImageView.aspectRatio()
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.leading.equalTo(tagBackgroundView.snp.trailing).offset(6)
            make.height.equalTo(tagBackgroundView)
        }
        
        addImageView.aspectRatio()
        addImageView.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.trailing.equalToSuperview()
            make.height.equalTo(tagBackgroundView)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.leading.equalTo(checkImageView.snp.trailing).offset(6)
            make.trailing.lessThanOrEqualTo(addImageView.snp.leading).offset(-6)
        }
        
        kalorieLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        kalorieLabel.setContentHuggingPriority(.init(1000), for: .horizontal)
        kalorieLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.trailing.equalTo(kalorieLabel.snp.leading).offset(-8)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(6)
            make.centerY.equalTo(titleLabel)
        }
    }
}
