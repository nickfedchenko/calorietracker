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
    
    var didTapButton: ((CellButtonType) -> Void)?
    var model: FoodViewModel?
    var color: UIColor? {
        didSet {
            infoLabel.textColor = color
        }
    }
    
    var infoCenterX: CGFloat = 0 {
        didSet {
            updateInfoLabelLayout()
        }
    }
    
    var cellButtonType: CellButtonType = .add {
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
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
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
        label.textColor = UIColor(hex: "111111")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 15)
        label.textColor = UIColor(hex: "547771")
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
        view.backgroundColor = UIColor(hex: "AFBEB8")
        return view
    }()
    
    private lazy var kalorieLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextBold(size: 15)
        label.textColor = R.color.addFood.menu.kcal()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextBold(size: 15)
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
        self.model = model
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        kalorieLabel.text = "\(Int(model.kcal))"
        checkImageView.isHidden = !model.verified
        
        if model.tag.isEmpty {
            tagBackgroundView.isHidden = true
            widthBackgroundTagViewConstraint?.isActive = false
            checkImageView.snp.remakeConstraints { make in
                make.centerY.equalTo(tagBackgroundView)
                make.leading.equalTo(titleLabel.snp.leading)
                //                make.trailing.lessThanOrEqualTo(descriptionLabel.snp.leading).offset(-6)
                make.height.equalTo(18)
            }
        } else {
            tagBackgroundView.isHidden = false
            tagLabel.text = model.tag
            widthBackgroundTagViewConstraint?.isActive = false
            checkImageView.snp.remakeConstraints { make in
                make.centerY.equalTo(tagBackgroundView)
                make.leading.lessThanOrEqualTo(tagLabel.snp.trailing).offset(12)
                make.trailing.lessThanOrEqualTo(descriptionLabel.snp.leading).offset(-6)
                make.height.equalTo(18)
            }
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
        layer.masksToBounds = false
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
            make.top.equalToSuperview().offset(9)
        }
        
        widthBackgroundTagViewConstraint = tagBackgroundView.widthAnchor.constraint(equalToConstant: 0)
        tagBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.leading.equalTo(tagLabel.snp.leading).offset(-5)
            make.trailing.equalTo(tagLabel.snp.trailing).offset(5)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(6)
        }
        
        checkImageView.aspectRatio()
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.leading.lessThanOrEqualTo(tagLabel.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(descriptionLabel.snp.leading).offset(-6)
            make.height.equalTo(18)
        }
        
        selectButton.aspectRatio()
        selectButton.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
        
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tagBackgroundView)
            make.trailing.equalTo(selectButton.snp.leading).offset(-6)
        }
        
        kalorieLabel.setContentCompressionResistancePriority(.init(rawValue: 753), for: .horizontal)
        kalorieLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(1)
            make.centerY.equalTo(titleLabel)
        }
        
        infoLabel.setContentCompressionResistancePriority(.init(rawValue: 753), for: .horizontal)
        infoLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(66)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    private func didChangeButtonType() {
        switch cellButtonType {
        case .delete:
            selectButton.setImage(R.image.addFood.recipesCell.addedCheckmark(), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.selectButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.selectButton.transform = .identity
                }
            }
        case .add:
            selectButton.setImage(R.image.addFood.recipesCell.add(), for: .normal)
        case .addToMeal:
            return
        }
    }
    
    @objc private func didTapSelectButton() {
        Vibration.success.vibrate()
        didTapButton?(cellButtonType)
        cellButtonType = cellButtonType == .add ? .delete : .add
    }
    
    private func updateInfoLabelLayout() {
        infoLabel.snp.remakeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.centerX.equalTo(infoCenterX)
        }
    }
}

extension FoodCellView.FoodViewModel {
    private init(_ product: Product, weight: Double?) {
        self.id = product.id
        self.title = product.title
        self.image = product.isUserProduct ? product.photo : nil
        self.verified = !product.isUserProduct
        var tag = ""
        if product.brand != nil && !product.isUserProduct {
            tag = (product.brand ?? "").isEmpty ? R.string.localizable.brandFood() : (product.brand ?? "")
        } else if product.isUserProduct {
            tag = R.string.localizable.tagUserProduct()
        } else {
            tag = R.string.localizable.baseFood()
        }
        
        self.tag = tag
        guard let servingValue = product.servings?.first?.weight else {
            self.description = ""
            self.kcal = 0
            return
        }
        if !product.isUserProduct {
            if let weight = weight {
                
                self.kcal = BAMeasurement(product.kcal / servingValue * weight, .energy, isMetric: true).localized
                let description = BAMeasurement(weight, .serving, isMetric: true).string(with: 0)
                self.description = description
            } else {
                self.kcal = BAMeasurement(product.kcal, .energy, isMetric: true).localized
                if let serving = product.servings?.first,
                   let unit = product.units?.first(where: { $0.isReference }) {
                    var description = ""
                    if unit.id == 1 {
                        description = "\(BAMeasurement(serving.weight ?? 1, .serving, isMetric: true).string(with: 1))"
                    } else {
                        description = "\(unit.title) "
                        + "(\(BAMeasurement(serving.weight ?? 1, .serving, isMetric: true).string(with: 1)))"
                    }
                    self.description = description
                } else {
                    self.description = ""
                }
            }
        } else {
            if let serving = product.servings?.first {
                let kcal = (serving.weight ?? 100) / servingValue * product.kcal
                self.kcal = BAMeasurement(kcal, .energy, isMetric: true).localized
                description = "(\(BAMeasurement(serving.weight ?? 1, .serving, isMetric: true).string(with: 1)))"
            } else {
                self.kcal = BAMeasurement(product.kcal, .energy, isMetric: true).localized
                description = ""
            }
        }
    }
    
    // MARK: - Model for food cells
    private init(_ dish: Dish, weight: Double?) {
        self.id = String(dish.id)
        self.title = dish.title
        self.tag = R.string.localizable.recipe()
        self.image = nil
        self.verified = true
        
        if let weight = weight,
           let totalWeight = dish.dishWeight {
            
            let portionWeight = (dish.dishWeight ?? 1) / Double(dish.totalServings ?? 1)
            let portions = weight / portionWeight
            let servingText: String = {
                switch portions {
                case 1:
                    return R.string.localizable.servings1()
                case 2...4:
                    return R.string.localizable.servings24()
                default:
                    return R.string.localizable.servings4()
                }
            }()
            self.kcal = BAMeasurement((weight / totalWeight) * dish.kcal, .energy, isMetric: true).localized
            self.description = "\(portions) \(servingText) "
            + "(\(BAMeasurement(portionWeight * Double(portions), .serving, isMetric: true).string(with: 1))"
        } else {
            var servingWeight: Double = 0
            if let servingDishWeight = dish.values?.serving.weight {
                servingWeight = servingDishWeight
            } else {
                let dishWeight = dish.dishWeight ?? 1
                let totalServing = dish.totalServings ?? 1
                servingWeight = dishWeight / Double(totalServing)
            }
            self.kcal = BAMeasurement(dish.values?.serving.kcal ?? 1, .energy, isMetric: true).localized
            self.description = "1 "
            + R.string.localizable.servings1()
            + " (\(BAMeasurement(servingWeight, .serving, isMetric: true).string(with: 1)))"
        }
    }
    
    private init(_ customEntry: CustomEntry, weight: Double?) {
        self.id = customEntry.id
        self.title = customEntry.title
        self.kcal = customEntry.nutrients.kcal
        self.tag = R.string.localizable.addFoodCustomEntry()
        self.image = nil
        self.verified = false
        self.description = ""
    }
    
    private init(product: Product, weight: Double?, unitData: FoodUnitData) {
        self.id = product.id
        self.title = product.title
        self.tag = product.brand ?? ""
        self.image = product.isUserProduct ? product.photo : nil
        self.verified = !product.isUserProduct
        
        if let weight = weight,
           let serving = product.servings?.first?.weight
        {
            self.kcal = BAMeasurement(product.kcal / serving * weight, .energy, isMetric: true).localized
            let descriptionWeight = BAMeasurement(weight, .serving, isMetric: true).string(with: 1)
            let unit = unitData.unit
            let unitCount = unitData.count
            let unitTitle = unit.getTitle(.short) ?? "error getting title"
            self.description = "\(unitCount) \(unitTitle) (\(descriptionWeight))"
        } else {
            self.kcal = BAMeasurement(product.kcal, .energy, isMetric: true).localized
            if let serving = product.servings?.first,
               let unit = product.units?.first(where: { $0.isReference }) {
                var description = ""
                if unit.id == 1 {
                    description = "\(BAMeasurement(serving.weight ?? 1, .serving, isMetric: true).string(with: 1)))"
                } else {
                    description = "\(unit.title) "
                    + "(\(BAMeasurement(serving.weight ?? 1, .serving, isMetric: true).string(with: 1)))"
                }
                self.description = description
            } else {
                self.description = ""
            }
        }
    }
    
    private init(_ meal: Meal, weight: Double?) {
        self.id = meal.id
        self.title = meal.title
        self.kcal = meal.nutrients.kcal
        self.tag = R.string.localizable.meal()
        self.image = nil
        self.verified = false
        self.description = ""
    }
    
    init?(_ food: Food?) {
        switch food {
        case .product(let product, let value, let unitData):
            if let unitData = unitData {
                self.init(product: product, weight: value, unitData: unitData)
            } else {
                self.init(product, weight: value)
            }
        case .dishes(let dish, let value):
            self.init(dish, weight: value)
        case .customEntry(let customEntry):
            self.init(customEntry, weight: nil)
        case .meal(let meal):
            self.init(meal, weight: nil)
        default:
            return nil
        }
    }
}
