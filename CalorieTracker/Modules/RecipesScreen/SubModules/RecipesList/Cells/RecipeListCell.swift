//
//  RecipeListCell.swift
//  GroceryList
//
//  Created by Vladimir Banushkin on 25.12.2022.
//

import UIKit
import Kingfisher

protocol RecipeListCellDelegate: AnyObject {
    func didTapToButProductsAtRecipe(at index: Int)
}

final class RecipeListCell: UICollectionViewCell {
    static let identifier = String(describing: RecipeListCell.self)
    var selectedIndex = -1
    weak var delegate: RecipeListCellDelegate?
    private var isFirstLayout = true
    private var shadowLayer: CAShapeLayer
    
    private let mainImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 8
        image.layer.cornerCurve = .continuous
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextSemibold(size: 16)
        label.textColor = UIColor(hex: "192621")
        label.textAlignment = .left
        label.numberOfLines = 2
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
    
    func configure(with dish: Dish) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 17.9
        let title = NSAttributedString(
            string: dish.title,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: R.font.sfProTextSemibold(size: 16) ?? .systemFont(ofSize: 16),
                .foregroundColor: UIColor(hex: "192621"),
                .kern: 0.38
            ]
        )
        titleLabel.attributedText = title
        if let url = URL(string: dish.photo) {
            mainImage.kf.setImage(with: url)
        }
        calorieValueLabel.text = String(format: "%.0f", dish.kcal)
        timerValueLabel.text = String(dish.cookTime)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawInlinedStroke()
    }
    
    override init(frame: CGRect) {
        shadowLayer = CAShapeLayer()
        super.init(frame: frame)
        setupSubviews()
        setupActions()
        clipsToBounds = false
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawShadows()
    }
    
    private func setupActions() {
        
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = .white
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.layer.cornerCurve = .continuous
        [titleLabel, mainImage, timerIcon, timerValueLabel, calorieIcon, calorieValueLabel].forEach {
            contentView.addSubview($0)
        }
        
        mainImage.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(96)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(mainImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(48)
        }
        
        timerIcon.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(14)
        }
        
        timerValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(timerIcon)
            make.top.equalTo(timerIcon.snp.bottom)
        }
        
        calorieIcon.snp.makeConstraints { make in
            make.centerX.equalTo(timerIcon)
            make.top.equalTo(timerValueLabel.snp.bottom).offset(4)
            make.width.height.equalTo(12)
        }
        
        calorieValueLabel.snp.makeConstraints { make in
            make.centerX.equalTo(calorieIcon)
            make.top.equalTo(calorieIcon.snp.bottom)
//            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    func drawInlinedStroke() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }
    
    private func drawShadows() {
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = UIColor(hex: "06BBBB").cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
        shadowLayer.shadowPath = shadowPath.cgPath
        shadowLayer.shadowColor = UIColor(hex: "123E5E").cgColor
        shadowLayer.shadowOpacity = 0.15
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        drawInlinedStroke()
    }
}
