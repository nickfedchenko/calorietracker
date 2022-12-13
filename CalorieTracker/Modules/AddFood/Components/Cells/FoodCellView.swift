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
        let kcal: Int
        let image: URL?
    }
    
    var didTapButton: (() -> Void)?
    
    var color: UIColor? {
        didSet {
            infoLabel.textColor = color
        }
    }
    
    var cellButtonType: FoodCollectionViewCell.CellButtonType = .add {
        didSet {
            didChangeButtonType()
        }
    }
    
    var subInfo: Int? {
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
        view.contentMode = .scaleAspectFit
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        tagLabel.text = model.tag
        kalorieLabel.text = "\(model.kcal)"
        
        if let imageUrl = model.image {
            imageView.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(),
                options: [
                    .processor(DownsamplingImageProcessor(
                        size: CGSize(width: 64, height: 64)
                    ))
                ]
            )
        }
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
    
    // swiftlint:disable:next function_body_length
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
        
        selectButton.aspectRatio()
        selectButton.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.trailing.equalToSuperview()
            make.height.equalTo(tagBackgroundView)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.leading.equalTo(checkImageView.snp.trailing).offset(6)
            make.trailing.lessThanOrEqualTo(selectButton.snp.leading).offset(-6)
        }
        
        kalorieLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        kalorieLabel.setContentHuggingPriority(.init(1000), for: .horizontal)
        kalorieLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }
        
        infoLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        infoLabel.setContentHuggingPriority(.init(1000), for: .horizontal)
        infoLabel.snp.makeConstraints { make in
            make.trailing.equalTo(kalorieLabel.snp.leading).offset(-8)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(6)
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
        didTapButton?()
    }
}

extension FoodCellView.FoodViewModel {
    private init(_ product: Product) {
        self.id = product.id
        self.title = product.title
        self.description = product.servings?
            .compactMap { $0.title }
            .joined(separator: ", ") ?? ""
        self.tag = product.brand ?? ""
        self.kcal = Int(product.kcal)
        self.image = nil
    }
    
    private init(_ dish: Dish) {
        self.id = String(dish.id)
        self.title = dish.title
        self.description = dish.info ?? ""
        self.tag = dish.tags.first?.tag ?? ""
        self.kcal = dish.kсal
        self.image = nil
    }
    
    init?(_ food: Food) {
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
