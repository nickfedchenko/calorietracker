//
//  DailyFoodIntakeCellView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.11.2022.
//

import UIKit

final class DailyFoodIntakeCellView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 16)
        label.textColor = R.color.foodViewing.basicDark()
        label.textAlignment = .center
        return label
    }()
    
    private let circleView = StatisticsCircleView()
    
    init(_ type: DailyFoodIntakeCircles) {
        super.init(frame: .zero)
        setupConstraints()
        
        circleView.backgroundCircleColor = type.getColors().background
        circleView.firstCircleColor = type.getColors().firstCircle
        circleView.secondCircleColor = type.getColors().secondCircle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: DailyFoodIntakeCellVM) {
        titleLabel.text = model.percent
    }
    
    private func setupConstraints() {
        addSubviews(titleLabel, circleView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        circleView.aspectRatio()
        circleView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
}
