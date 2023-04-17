//
//  IngredientView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 13.01.2023.
//

import UIKit

final class IngredientView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let servingLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 16)
        label.textColor = UIColor(hex: "547771")
        label.textAlignment = .right
        label.numberOfLines = 2
        return label
    }()
    
    private let calorieLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedSemibold(size: 17)
        label.textAlignment = .right
        label.textColor = UIColor(hex: "FF764B")
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: RecipeIngredientModel) {
        titleLabel.text = model.title
        if model.unitsAmount > 0 {
            servingLabel.text = String(
                format: "%.\(model.unitsAmount.truncatingRemainder(dividingBy: 1) > 0 ? 1 : 0)f",
                model.unitsAmount) + " " + model.unitTitle
        } else {
            servingLabel.text = "ByTaste".localized
        }
        calorieLabel.text = String(format: "%.0f", model.kcal)
    }
    
    private func setupAppearance() {
        backgroundColor = .white
        layer.cornerRadius = 8
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setServing(serving: String) {
        servingLabel.text = serving
    }
    
    func setCalories(calories: String) {
        calorieLabel.text = calories
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(servingLabel)
        addSubview(calorieLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.width.lessThanOrEqualTo(240.fitW).priority(.low)
        }
        
        servingLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(59)
            make.leading.equalTo(titleLabel.snp.trailing).offset(12).priority(.high)
        }
        
        calorieLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(servingLabel)
            make.trailing.equalToSuperview().inset(8)
            make.leading.equalTo(servingLabel.snp.trailing).offset(6)
        }
    }
}
