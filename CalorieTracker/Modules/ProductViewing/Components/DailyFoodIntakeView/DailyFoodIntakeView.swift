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
        label.textAlignment = .center
        label.text = "Percent of daily goal"
        return label
    }()
    
    private lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.foodViewing.basicPrimary()?.withAlphaComponent(0.7)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.cornerCurve = .circular
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = R.color.foodViewing.basicPrimary()?
            .withAlphaComponent(0.7)
            .cgColor
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
