//
//  MealsCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 06.03.2023.
//

import Kingfisher
import UIKit

final class MealsCollectionViewCell: UICollectionViewCell {
    
    enum MealCellButtonType {
        case delete
        case add
    }
    
    var meal: Meal? {
        didSet {
            configureMealCell()
        }
    }
    
    var cellButtonType: MealCellButtonType = .add {
        didSet {
            didChangeButtonType()
        }
    }
    
    var foods: [Food] = []
    var didTapButton: ((MealCellButtonType) -> Void)?

    private let shadowView = ViewWithShadow([
        ShadowConst.firstShadow,
        ShadowConst.secondShadow
    ])
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 15)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 13)
        label.textColor = UIColor(hex: "547771")
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var mealPhotoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        view.backgroundColor = R.color.basicSecondaryDarkGreen()
        return view
    }()
    
    private lazy var kcalLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextBold(size: 15)
        label.textColor = R.color.addFood.menu.kcal()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var kcalImageView: UIImageView = {
        let view = UIImageView(
            image: R.image.createMeal.flame()
        )
        return view
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let view = UIImageView(
            image: R.image.createMeal.chevron()
        )
        return view
    }()
    
     private lazy var addToDiaryButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.createMeal.add(), for: .normal)
        button.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MealTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.rowHeight = 57
        
        let tableHeaderView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: contentView.frame.size.width,
            height: 2)
        )
        
        tableHeaderView.backgroundColor = .clear
        let separator = UIView(frame: CGRect(
            x: 20,
            y: 0,
            width: tableHeaderView.frame.size.width,
            height: 2)
        )
        separator.backgroundColor = R.color.basicSecondaryDarkGreen()
        tableHeaderView.addSubview(separator)
        tableView.tableHeaderView = tableHeaderView
        
        return tableView
    }()
    
    lazy var editMealButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#F3FFFE")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#62D3B4").cgColor
        button.layer.cornerRadius = 8
        button.setTitle(R.string.localizable.addFoodEditMeal(), for: .normal)
        button.setImage(R.image.addFood.edit(), for: .normal)
        button.setTitleColor(UIColor(hex: "#0C695E"), for: .normal)
        button.titleLabel?.font = R.font.sfProRoundedSemibold(size: 16)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.layer.cornerCurve = .continuous
        return button
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
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width,
                                height: layoutAttributes.frame.height)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [titleLabel, descriptionLabel, kcalLabel].forEach {
            $0.text = nil
        }
        
        mealPhotoImageView.image = nil
    }
    
    private func setupView() {
        
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = false
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.cornerRadius = 8
        
        clipsToBounds = false
        layer.masksToBounds = false
        
        shadowView.layer.cornerRadius = 8
    }
    
    private func addSubviews() {
        contentView.addSubviews(
            shadowView,
            mealPhotoImageView,
            chevronImageView,
            titleLabel,
            kcalImageView,
            kcalLabel,
            descriptionLabel,
            addToDiaryButton,
            tableView
        )
    }
    
    private func setupConstraints() {
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mealPhotoImageView.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.width.equalTo(96)
            make.top.leading.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.top.equalTo(mealPhotoImageView.snp.bottom)
            make.centerX.equalTo(mealPhotoImageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(mealPhotoImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-48)
        }
        
        kcalImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(24)
        }
        
        kcalLabel.snp.makeConstraints { make in
            make.top.equalTo(kcalImageView.snp.bottom)
            make.centerX.equalTo(kcalImageView)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(mealPhotoImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-48)
        }
        
        addToDiaryButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.top.equalTo(kcalLabel.snp.bottom).offset(24)
            make.centerX.equalTo(kcalLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(104)
            make.leading.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    func getDescriptionText() -> String {
        guard let meal = meal else { return "" }

        var ingredients = [String]()
        meal.products.forEach { ingredients.append($0.title) }
        meal.dishes.forEach { ingredients.append($0.title) }
        meal.customEntries.forEach { ingredients.append($0.title) }

        return ingredients.joined(separator: ", ")
    }
    
    func getKcalText() -> String {
        guard let meal = meal else { return "" }
        
        let kcalSum = meal.products.reduce(0) { $0 + $1.kcal } +
        meal.dishes.reduce(0) { $0 + $1.kcal } +
        meal.customEntries.reduce(0) { $0 + $1.nutrients.kcal }
        
        return String(format: "%.0f", kcalSum)
    }
    
    private func configureMealCell() {
        guard let meal else { return }
        titleLabel.text = meal.title
        descriptionLabel.text = getDescriptionText()
        mealPhotoImageView.kf.setImage(with: URL(string: meal.photoURL))
        kcalLabel.text = getKcalText()
        addFoods(from: meal)
    }
    
    private func addFoods(from meal: Meal) {
        foods = meal.products.foods +
        meal.dishes.foods +
        meal.customEntries.foods
        tableView.reloadData()
    }
    
    private func configure(_ cell: MealTableViewCell, at indexPath: IndexPath) {
        guard let foodType = foods[safe: indexPath.row] else {
            return
        }
        
        var viewModel: CreateMealCellViewModel
        
        switch foodType {
        case .product(let product, _, _):
            viewModel = CreateMealCellViewModel(
                title: product.title,
                tag: product.brand,
                kcal: "\(Int(product.kcal.rounded()))",
                weight: "\(Int(product.servings?.first?.weight?.rounded() ?? 0.0)) g"
            )
        case .dishes(let dish, _):
            viewModel = CreateMealCellViewModel(
                title: dish.title,
                tag: dish.eatingTags.first?.title,
                kcal: "\(Int(dish.kcal.rounded()))",
                weight: "\(Int(dish.dishWeight ?? 0.0)) g"
            )
        case .customEntry(let customEntry):
            viewModel = CreateMealCellViewModel(
                title: customEntry.title,
                tag: R.string.localizable.addFoodCustomEntry().capitalized,
                kcal: "\(Int(customEntry.nutrients.kcal.rounded()))",
                weight: nil
            )
        case .meal:
            return
        }
        
        cell.configure(with: viewModel)
    }
    
    private func didChangeButtonType() {
        switch cellButtonType {
        case .delete:
            addToDiaryButton.setImage(R.image.addFood.recipesCell.addedCheckmark(), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.addToDiaryButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.addToDiaryButton.transform = .identity
                }
            }
        case .add:
            addToDiaryButton.setImage(R.image.createMeal.add(), for: .normal)
        }
    }
    
    @objc private func didTapSelectButton() {
        Vibration.success.vibrate()
        didTapButton?(cellButtonType)
        cellButtonType = cellButtonType == .add ? .delete : .add
    }
}

extension MealsCollectionViewCell {
    struct ShadowConst {
        static let firstShadow = Shadow(
            color: UIColor(hex: "#123E5E"),
            opacity: 0.25,
            offset: CGSize(width: 0, height: 0.5),
            radius: 2,
            spread: 0
        )
        static let secondShadow = Shadow(
            color: UIColor(hex: "#06BBBB"),
            opacity: 0.2,
            offset: CGSize(width: 0, height: 4),
            radius: 10,
            spread: 0
        )
    }
}

extension MealsCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MealTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        configure(cell, at: indexPath)
        cell.backgroundColor = .clear
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.containerView.addSubview(editMealButton)
            cell.checkMarkImage.isHidden = true
            
            editMealButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
                make.height.equalTo(36)
                make.width.equalTo(120)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 ? 50 : 57
    }
}
