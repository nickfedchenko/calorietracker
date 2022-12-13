//
//  FoodCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.11.2022.
//

import UIKit

final class FoodCollectionViewCell: UICollectionViewCell, FoodCellProtocol {
    enum CellType {
        case table
        case withShadow
    }
    
    enum CellButtonType {
        case delete
        case add
    }
    
    var foodType: Food? {
        didSet {
            self.configure()
        }
    }
    
    var cellType: CellType = .table {
        didSet {
            didChangeCellType()
        }
    }
    
    var cellButtonType: CellButtonType = .add {
        didSet {
            foodView.cellButtonType = cellButtonType
        }
    }
    
    var colorSubInfo: UIColor? {
        didSet {
            foodView.color = colorSubInfo
        }
    }
    
    var subInfo: Int? {
        didSet {
            foodView.subInfo = subInfo
        }
    }
    
    var didTapButton: ((Food) -> Void)?
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.addFood.recipesCell.line()
        return view
    }()
    
    private let foodView = FoodCellView()
    private let shadowLayer = CALayer()

    private var firstDraw = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstDraw else { return }
        setupShadow()
        firstDraw = false
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
        guard let foodType = foodType else { return }
        
        foodView.configure(.init(foodType))
    }
    
    private func setupView() {
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        clipsToBounds = false
        layer.masksToBounds = false
        
        layer.insertSublayer(shadowLayer, at: 0)
        
        foodView.didTapButton = {
            guard let foodType = self.foodType else { return }
            self.didTapButton?(foodType)
        }
    }
    
    private func addSubviews() {
        contentView.addSubviews(foodView, bottomLineView)
    }
    
    private func setupConstraints() {
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
            shadowLayer.isHidden = true
            bottomLineView.isHidden = false
        case .withShadow:
            shadowLayer.isHidden = false
            bottomLineView.isHidden = true
        }
    }
    
    private func setupShadow() {
        shadowLayer.frame = bounds
        shadowLayer.addShadow(
            shadow: ShadowConst.firstShadow,
            rect: bounds,
            cornerRadius: 8
        )
        shadowLayer.addShadow(
            shadow: ShadowConst.secondShadow,
            rect: bounds,
            cornerRadius: 8
        )
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
