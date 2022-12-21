//
//  SettingsNutrientGoalView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

import UIKit

final class SettingsNutrientGoalView: UIView {
    
    var viewModel: SettingsNutrientGoalCellViewModel? {
        didSet {
            didSetViewModel()
        }
    }
    
    var didChangePercent: ((Float) -> Void)?
    
    private lazy var slider: UISlider = getSlider()
    private lazy var percentTitleLabel: UILabel = getLargeTitleLabel()
    private lazy var nutrientTypeTitleLabel: UILabel = getLargeTitleLabel()
    private lazy var kcalTitleLabel: UILabel = getLargeTitleLabel()
    private lazy var weightTitleLabel: UILabel = getMediumTitleLabel()
    private lazy var weightBackgroundView: UIView = getWeightBackgroundView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didSetViewModel() {
        percentTitleLabel.textColor = viewModel?.getTitleColor()
        nutrientTypeTitleLabel.textColor = viewModel?.getTitleColor()
        slider.tintColor = viewModel?.getSliderColor()
        slider.setThumbImage(
            thumbImage(radius: 14, color: viewModel?.getTitleColor()),
            for: .normal
        )
    }
    
    private func setupView() {
        kcalTitleLabel.textColor = R.color.foodViewing.basicDarkGrey()
        weightTitleLabel.textColor = R.color.foodViewing.basicDark()
        
        weightTitleLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        addSubviews(
            percentTitleLabel,
            nutrientTypeTitleLabel,
            kcalTitleLabel,
            weightBackgroundView,
            slider
        )
        
        weightBackgroundView.addSubview(weightTitleLabel)
        
        slider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        weightBackgroundView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        weightBackgroundView.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualTo(slider.snp.top)
            make.width.equalTo(62)
        }
        
        weightTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.greaterThanOrEqualToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        percentTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualTo(slider)
        }
        
        nutrientTypeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(percentTitleLabel.snp.trailing).offset(8)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualTo(slider)
        }
        
        kcalTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(nutrientTypeTitleLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(weightBackgroundView).offset(-8)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualTo(slider)
        }
    }
    
    private func thumbImage(radius: CGFloat, color: UIColor?) -> UIImage {
        let thumbView = UIView()
        
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        thumbView.layer.cornerCurve = .circular
        thumbView.layer.borderColor = UIColor.white.cgColor
        thumbView.layer.borderWidth = 2
        thumbView.backgroundColor = color
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    @objc private func didChangeSliderValue() {
        viewModel?.setPercent(Int(slider.value * 100))
        didChangePercent?(slider.value)
    }
}

extension SettingsNutrientGoalView: SettingsNutrientGoalCellViewModelOutput {
    func updateView(percentTitle: String,
                    nutrientTypeTitle: String,
                    kcalTitle: String,
                    weightTitle: String,
                    percentForSlider: Float) {
        percentTitleLabel.text = percentTitle
        nutrientTypeTitleLabel.text = nutrientTypeTitle
        kcalTitleLabel.text = kcalTitle
        weightTitleLabel.text = weightTitle
        slider.value = percentForSlider
    }
}

// MARK: - Factory

extension SettingsNutrientGoalView {
    private func getSlider() -> UISlider {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        return slider
    }
    
    private func getLargeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplayBold(size: 14.fontScale())
        return label
    }
    
    private func getMediumTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 14.fontScale())
        return label
    }
    
    private func getWeightBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
        return view
    }
}
