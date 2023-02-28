//
//  FoodCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.11.2022.
//

import UIKit

final class FoodCollectionViewCell: UICollectionViewCell, FoodCellProtocol {
    var viewModel: FoodCellViewModel? {
        didSet {
            configure()
        }
    }
    
    var bottomLineIsHidden: Bool {
        get { bottomLineView.isHidden }
        set { bottomLineView.isHidden = newValue }
    }
    
    var foodType: Food?
    var didTapButton: ((Food, CellButtonType) -> Void)?
    var infoCenterX: CGFloat = 0 {
        didSet {
            foodView.infoCenterX = infoCenterX
        }
    }
    
    private var cellType: CellType = .table {
        didSet {
            didChangeCellType()
        }
    }
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.addFood.recipesCell.line()
        return view
    }()
    
    private let foodView = FoodCellView()
    private let shadowView = ViewWithShadow([
        ShadowConst.firstShadow,
        ShadowConst.secondShadow
    ])

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func turnIntoOpenMainWidgetState() {
        foodView.backgroundColor = .clear
    }
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }
    
    private func configure() {
        guard let model = viewModel else { return }
        foodView.configure(.init(model.food))
        foodView.color = model.colorSubInfo
        foodView.subInfo = model.subInfo
        foodView.cellButtonType = model.buttonType
        cellType = model.cellType
        foodType = model.food
    }
    
    private func setupView() {
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        clipsToBounds = false
        layer.masksToBounds = false
        
        shadowView.layer.cornerRadius = 8
        
        foodView.didTapButton = { buttonType in
            guard let foodType = self.viewModel?.food else { return }
            switch foodType {
            case .product(let product, _, _):
                self.didTapButton?(
                    .product(product, customAmount: product.servings?.first?.weight ?? 0, unit: nil), buttonType
                )
            case .dishes(let dish, _):
                self.didTapButton?(
                    .dishes(dish, customAmount: (dish.dishWeight ?? 0) / Double(dish.totalServings ?? 1)),
                    buttonType
                )
            case .meal(let meal):
                self.didTapButton?(.meal(meal), buttonType)
            case .customEntry(let customEntry):
                self.didTapButton?(.customEntry(customEntry), buttonType)
            }
        }
    }
    
    private func addSubviews() {
        contentView.addSubviews(
            shadowView,
            foodView,
            bottomLineView
        )
    }
    
    private func setupConstraints() {
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        foodView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func didChangeCellType() {
        switch cellType {
        case .table:
            shadowView.isHidden = true
            foodView.layer.cornerRadius = 0
        case .withShadow:
            shadowView.isHidden = false
            bottomLineView.isHidden = true
            foodView.layer.cornerRadius = 8
        }
    }
}

extension FoodCollectionViewCell {
    struct ShadowConst {
        static let firstShadow = Shadow(
            color: R.color.addFood.menu.firstShadow() ?? .black,
            opacity: 0.1,
            offset: CGSize(width: 0, height: 4),
            radius: 10
        )
        static let secondShadow = Shadow(
            color: R.color.addFood.menu.secondShadow() ?? .black,
            opacity: 0.15,
            offset: CGSize(width: 0, height: 0.5),
            radius: 2
        )
    }
}
