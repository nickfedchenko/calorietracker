//
//  PrototypeCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 04.08.2022.
//

import AsyncDisplayKit

final class RecipePreviewCell: UICollectionViewCell {
   private var isFirstLayout = true
    static let identifier = String(describing: RecipePreviewCell.self)
    private let shadowLayer = CAShapeLayer()
    
    private let mainImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.layer.cornerCurve = .continuous
        image.layer.maskedCorners = [.layerMinXMinYCorner]
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextSemibold(size: 15)
        label.textColor = R.color.grayBasicDark()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Air fryer bacon"
        return label
    }()
    
    private let timerValueLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 12)
        label.textColor = R.color.grayBasicGray()
        label.textAlignment = .center
        label.text = "35"
        return label
    }()
    
    private let timerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.timerIcon()
        return imageView
    }()
    
    private let calorieValueLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 12)
        label.textColor = R.color.darkCarrot()
        label.textAlignment = .center
        label.text = "1124"
        return label
    }()
    
    private let calorieIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.calorieIcon()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func configure(with model: LightweightRecipeModel) {
        if let photoUrl = model.photoUrl {
            mainImage.kf.setImage(with: photoUrl)
        }
        titleLabel.text = model.title
        timerValueLabel.text = String(model.cookingTime)
        calorieValueLabel.text = String(format: "%.0f", model.servingKcal ?? 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawShadows()
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = .white
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 8
        contentView.layer.cornerCurve = .continuous
        contentView.addSubviews(titleLabel, mainImage, timerIcon, timerValueLabel, calorieIcon, calorieValueLabel)
        
        mainImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8).priority(.low)
        }
        
        timerIcon.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(12)
//            make.leading.equalTo(mainImage.snp.trailing).offset(12)
        }
        
        timerValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(timerIcon)
            make.top.equalTo(timerIcon.snp.bottom)
        }
        
        calorieIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.equalTo(timerValueLabel.snp.bottom).offset(8)
            make.centerX.equalTo(timerValueLabel)
        }
        
        calorieValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(calorieIcon)
            make.top.equalTo(calorieIcon.snp.bottom)
        }
    }
    
    private func drawShadows() {
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = R.color.widgetShadowColorMainLayer()?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowColor = R.color.widgetShadowColorSecondaryLayer()?.cgColor
        shadowLayer.shadowOpacity = 0.25
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        drawInlinedStroke()
    }
    
    func drawInlinedStroke() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }
}
