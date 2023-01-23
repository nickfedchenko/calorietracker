//
//  FoodCellView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.11.2022.
//

import Kingfisher
import UIKit

final class FoodCellView: UIView {
    struct FoodViewModel {
        let id: String
        let title: String
        let description: String
        let tag: String
        let kcal: Double
        let image: Product.Photo?
        let verified: Bool
    }
    
    var didTapButton: (() -> Void)?
    
    var color: UIColor? {
        didSet {
            infoLabel.textColor = color
        }
    }
    
    var cellButtonType: CellButtonType = .add {
        didSet {
            didChangeButtonType()
        }
    }
    
    var subInfo: Double? {
        didSet {
            if let info = subInfo {
                infoLabel.text = "\(info)"
            } else {
                infoLabel.text = nil
            }
        }
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        return button
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
        label.numberOfLines = 0
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
    
    private var widthBackgroundTagViewConstraint: NSLayoutConstraint?
    private var widthImageViewConstraints: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
        didChangeButtonType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: FoodViewModel?) {
        guard let model = model else { return }
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        kalorieLabel.text = "\(model.kcal)"
        checkImageView.isHidden = !model.verified
        
        if model.tag.isEmpty {
            tagBackgroundView.isHidden = true
            widthBackgroundTagViewConstraint?.isActive = true
        } else {
            tagBackgroundView.isHidden = false
            tagLabel.text = model.tag
            widthBackgroundTagViewConstraint?.isActive = false
        }
        
        if let image = model.image {
            widthImageViewConstraints?.isActive = false
            switch image {
            case .url(let url):
                imageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(),
                    options: [
                        .processor(DownsamplingImageProcessor(
                            size: CGSize(width: 64, height: 64)
                        ))
                    ]
                )
            case .data(let data):
                imageView.image = UIImage(data: data)
            }
        } else {
            imageView.image = nil
            widthImageViewConstraints?.isActive = true
        }
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.masksToBounds = true
    }
    
    private func addSubviews() {
        tagBackgroundView.addSubview(tagLabel)
        
        addSubviews(
            imageView,
            selectButton,
            checkImageView,
            titleLabel,
            descriptionLabel,
            kalorieLabel,
            infoLabel,
            tagBackgroundView
        )
    }
    
    private func setupConstraints() {
        widthImageViewConstraints = imageView.widthAnchor.constraint(equalToConstant: 0)
        imageView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(snp.height)
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.init(rawValue: 751), for: .vertical)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualTo(infoLabel.snp.leading).offset(-6)
            make.top.equalToSuperview().offset(4)
        }
        
        widthBackgroundTagViewConstraint = tagBackgroundView.widthAnchor.constraint(equalToConstant: 0)
        tagBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.leading.equalTo(imageView.snp.trailing).offset(4)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-7)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        checkImageView.aspectRatio()
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.leading.equalTo(tagBackgroundView.snp.trailing).offset(6)
            make.trailing.lessThanOrEqualTo(descriptionLabel.snp.leading).offset(-6)
            make.height.equalTo(18)
        }
        
        selectButton.aspectRatio()
        selectButton.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.trailing.equalTo(selectButton.snp.leading).offset(-6)
        }
        
        kalorieLabel.setContentCompressionResistancePriority(.init(rawValue: 753), for: .horizontal)
        kalorieLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
        
        infoLabel.setContentCompressionResistancePriority(.init(rawValue: 753), for: .horizontal)
        infoLabel.snp.makeConstraints { make in
            make.trailing.equalTo(kalorieLabel.snp.leading).offset(-8)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    private func didChangeButtonType() {
        switch cellButtonType {
        case .delete:
            selectButton.setImage(R.image.addFood.recipesCell.delete(), for: .normal)
        case .add:
            selectButton.setImage(R.image.addFood.recipesCell.add(), for: .normal)
        }
    }
    
    @objc private func didTapSelectButton() {
        Vibration.success.vibrate()
        didTapButton?()
    }
}

extension FoodCellView.FoodViewModel {
    private init(_ product: Product) {
        self.id = product.id
        self.title = product.title
        self.description = product.servings?
            .compactMap { $0.size }
            .joined(separator: ", ") ?? ""
        self.tag = product.brand ?? ""
        self.kcal = product.kcal
        self.image = product.isUserProduct ? product.photo : nil
        self.verified = !product.isUserProduct
    }
    
    private init(_ dish: Dish) {
        self.id = String(dish.id)
        self.title = dish.title
        self.description = dish.info ?? ""
        self.tag = dish.eatingTags.first?.title ?? ""
        self.kcal = dish.kcal
        self.image = nil
        self.verified = true
    }
    
    init?(_ food: Food?) {
        switch food {
        case .product(let product):
            self.init(product)
        case .dishes(let dish):
            self.init(dish)
        default:
            return nil
        }
    }
}
