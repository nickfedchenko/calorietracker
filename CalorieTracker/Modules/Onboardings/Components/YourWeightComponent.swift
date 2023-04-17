//
//  YourWeightComponent.swift
//  CalorieTracker
//
//  Created by Алексей on 05.09.2022.
//

import UIKit

class YourWeightComponent: UIView {
    
    // MARK: - Style
    
    enum Style {
        case current
        case target
    }
    
    // MARK: - Private properties
    
    private let style: Style
    
    // MARK: - View properties
    
    private let stackView: UIStackView = .init()
    private let imageView: UIImageView = .init()
    private let titleLabe: UILabel = .init()
    private let weightLabel: UILabel = .init()
    
    // MARK: - Initialization
    
    init(style: Style) {
        self.style = style
        
        super.init(frame: .zero)
        
        configureViews()
        configureLayouts()
        didChangedStyle()
    }
    
    private func configureViews() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 8, height: 8)
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 12
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.distribution = .fillProportionally
        
        titleLabe.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabe.textColor = .white
        titleLabe.numberOfLines = 0
        titleLabe.textAlignment = .center
        
        weightLabel.font = .systemFont(ofSize: 28, weight: .bold)
        weightLabel.textColor = .white
    }
    
    private func configureLayouts() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabe)
        stackView.addArrangedSubview(weightLabel)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(16)
            $0.left.equalTo(snp.left).offset(20)
            $0.right.equalTo(snp.right).offset(-20)
            $0.bottom.equalTo(snp.bottom).offset(-22)
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }
    
    private func didChangedStyle() {
        switch style {
        case .current:
            backgroundColor = R.color.onboardings.currentWeight()
            titleLabe.text = R.string.localizable.onboardingCurrentWeight()
            imageView.image = R.image.onboardings.location()
        case .target:
            backgroundColor = R.color.onboardings.radialGradientFirst()
            titleLabe.text = R.string.localizable.onboardingTargetweight()
            imageView.image = R.image.onboardings.gps()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YourWeightComponent {
    func set(yourCurrentWeight: Double) {
        weightLabel.text = BAMeasurement(yourCurrentWeight, .weight, isMetric: true).string(with: 1)
    }
    
    func set(yourTargetWeight: Double) {
        weightLabel.text = BAMeasurement(yourTargetWeight, .weight, isMetric: true).string(with: 1)
    }
}
