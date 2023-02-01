//
//  DailyFoodIntakeView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.11.2022.
//

import UIKit

final class DailyFoodIntakeView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 17)
        label.textColor = R.color.foodViewing.basicDark()
        label.clipsToBounds = false
        label.textAlignment = .center
        label.text = R.string.localizable.productDailyFoodIntakeTitle()
        return label
    }()
    
    private lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.foodViewing.basicSecondaryDark()
        return view
    }()
    
    private lazy var circlesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 18
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var fatCircleView = getCircleView(.fat)
    private lazy var carbCircleView = getCircleView(.carb)
    private lazy var kcalCircleView = getCircleView(.kcal)
    private lazy var proteinCircleView = getCircleView(.protein)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    func configure(from: DailyNutrition, to: DailyNutrition, goal: DailyNutrition) {
        let from = NutrientMeasurment.convertNutrition(nutrition: from, from: .kcal, to: .gram)
        let goal = NutrientMeasurment.convertNutrition(nutrition: goal, from: .kcal, to: .gram)
        fatCircleView.configure(.init(
            percent: String(format: "%.1f", (from.fat + to.fat) / goal.fat * 100) + "%",
            value: String(format: "%.1f g", from.fat + to.fat),
            now: from.fat / goal.fat,
            add: to.fat / goal.fat
        ))
        carbCircleView.configure(.init(
            percent: String(format: "%.1f", (from.carbs + to.carbs) / goal.carbs * 100) + "%",
            value: String(format: "%.1f g", from.carbs + to.carbs),
            now: from.carbs / goal.carbs,
            add: to.carbs / goal.carbs
        ))
        kcalCircleView.configure(.init(
            percent: String(format: "%.1f", (from.kcal + to.kcal) / goal.kcal * 100) + "%",
            value: String(Int(from.kcal + to.kcal)),
            now: from.kcal / goal.kcal,
            add: to.kcal / goal.kcal
        ))
        proteinCircleView.configure(.init(
            percent: String(format: "%.1f", (from.protein + to.protein) / goal.protein * 100) + "%",
            value: String(format: "%.1f g", from.protein + to.protein),
            now: from.protein / goal.protein,
            add: to.protein / goal.protein
        ))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.cornerCurve = .circular
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
    }
    
    private func addSubviews() {
        circlesStackView.addArrangedSubviews(
            carbCircleView,
            proteinCircleView,
            fatCircleView,
            kcalCircleView
        )
        
        addSubviews(
            titleLabel,
            separatorLineView,
            circlesStackView
        )
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(10)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        circlesStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(separatorLineView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}

extension DailyFoodIntakeView {
    private func getCircleView(_ type: DailyFoodIntakeCircles) -> DailyFoodIntakeCellView {
        let view = DailyFoodIntakeCellView(type)
        return view
    }
}
