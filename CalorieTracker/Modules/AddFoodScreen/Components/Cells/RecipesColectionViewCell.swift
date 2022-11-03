//
//  RecipesColectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.11.2022.
//

import UIKit

final class RecipesColectionViewCell: UICollectionViewCell {
    struct RecipeViewModel {
        let image: UIImage?
        let title: String
        let kalories: Int
        let time: Int
    }
    
    private let containerView = UIView()
    private let ceneredView = UIView()
    
    private lazy var recipeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplayBold(size: 15)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let timeView = ImageAndTitleVerticalView(
        R.image.addFood.recipesCell.time(),
        color: R.color.addFood.recipesCell.basicGray()
    )
    
    private let kaloriesView = ImageAndTitleVerticalView(
        R.image.addFood.recipesCell.fire(),
        color: R.color.addFood.recipesCell.kalories()
    )
    
    private var firstDraw = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    func configure(_ model: RecipeViewModel) {
        recipeImageView.image = model.image
        titleLabel.text = model.title
        timeView.configure(String(model.time))
        kaloriesView.configure(String(model.kalories))
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
        
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
        ceneredView.addSubviews(timeView, kaloriesView)
        containerView.addSubviews(
            ceneredView,
            recipeImageView,
            titleLabel
        )
    }
    
    private func setupConstraints() {
        recipeImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.26)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(recipeImageView.snp.trailing).offset(8)
            make.bottom.top.equalToSuperview()
            make.trailing.equalTo(ceneredView.snp.leading).offset(-8)
        }
        
        ceneredView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.11)
        }
        
        timeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(kaloriesView)
        }
        
        kaloriesView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func setupShadow() {
        layer.addShadow(
            shadow: MenuView.ShadowConst.firstShadow,
            rect: bounds,
            cornerRadius: layer.cornerRadius
        )
        layer.addShadow(
            shadow: MenuView.ShadowConst.secondShadow,
            rect: bounds,
            cornerRadius: layer.cornerRadius
        )
    }
}

extension RecipesColectionViewCell {
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
