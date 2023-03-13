//
//  OnboardingChart.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 24.12.2022.
//

import UIKit

final class OnboardingChartView: ViewWithShadow {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = R.font.sfProDisplaySemibold(size: 16.fontScale())
        label.textAlignment = .center
        label.text = R.string.localizable.onboardingChartTitle()
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.foodViewing.basicGrey()
        label.font = R.font.sfProDisplaySemibold(size: 14.fontScale())
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nowLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.onboardings.borders()
        label.font = R.font.sfProTextMedium(size: 13.fontScale())
        label.text = R.string.localizable.onboardingChartNow()
        return label
    }()
    
    private lazy var chartImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var dateBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 2
        view.layer.borderWidth = 1
        view.layer.borderColor = R.color.onboardings.borders()?.cgColor
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.onboardings.borders()
        label.font = R.font.sfProTextMedium(size: 13.fontScale())
        return label
    }()
    
    init() {
        super.init(Const.shadows)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(date: Date, weightGoal: WeightGoal) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        let largeDateStr = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMMM yyyy"
        let yearDateStr = dateFormatter.string(from: date)
        
        let description = R.string.localizable.onboardingChartDescription()
        descriptionLabel.text = "\(description) \(yearDateStr)."
        dateLabel.text = largeDateStr
        
        switch weightGoal {
        case .gain:
            chartImageView.image = R.image.onboardings.upWeightChart()
        case .loss:
            chartImageView.image = R.image.onboardings.downWeightChart()
        }
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
        backgroundColor = .white
    }
    
    private func setupConstraints() {
        addSubviews(
            titleLabel,
            chartImageView,
            nowLabel,
            dateBackground,
            descriptionLabel
        )
        
        dateBackground.addSubview(dateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        chartImageView.aspectRatio(0.297)
        chartImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        nowLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(chartImageView.snp.bottom).offset(9)
        }
        
        dateBackground.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(chartImageView.snp.bottom).offset(9)
            make.leading.greaterThanOrEqualTo(nowLabel.snp.trailing)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(1)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nowLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-17)
        }
    }
}

extension OnboardingChartView {
    struct Const {
        static let shadows: [Shadow] = [
            .init(
                color: .black,
                opacity: 0.03,
                offset: CGSize(width: 0, height: 1),
                radius: 16,
                spread: 0
            ),
            .init(
                color: .black,
                opacity: 0.03,
                offset: CGSize(width: 0, height: 6),
                radius: 8,
                spread: 0
            )
        ]
    }
}
