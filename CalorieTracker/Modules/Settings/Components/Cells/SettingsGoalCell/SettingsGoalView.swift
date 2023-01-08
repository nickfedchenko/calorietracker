//
//  SettingsGoalView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import UIKit

final class SettingsGoalView: UIView {
    
    var viewModel: SettingsGoalCellViewModel? {
        didSet {
            updateViewModel()
        }
    }
    
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var leftDescriptionLabel: UILabel = getLeftDescriptionLabel()
    private lazy var rightDescriptionLabel: UILabel = getRightDescriptionLabel()
    private lazy var rightButton: UIButton = getRightButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViewModel() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        leftDescriptionLabel.text = viewModel.leftDescription ?? ""
        rightDescriptionLabel.text = viewModel.rightDescription ?? ""
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        backgroundColor = .white
    }
    
    private func setupConstraints() {
        addSubviews(
            titleLabel,
            leftDescriptionLabel,
            rightDescriptionLabel,
            rightButton
        )
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.bottom.top.lessThanOrEqualToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        leftDescriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.bottom.top.lessThanOrEqualToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        rightDescriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.bottom.top.lessThanOrEqualToSuperview()
            make.trailing.equalTo(rightButton.snp.leading).offset(-12)
            make.leading.greaterThanOrEqualTo(leftDescriptionLabel.snp.trailing).offset(8)
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.height.width.equalTo(32)
            make.bottom.top.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Factory

extension SettingsGoalView {
    private func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        return label
    }
    
    private func getLeftDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.foodViewing.basicDarkGrey()
        return label
    }
    
    private func getRightDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.foodViewing.basicPrimary()
        label.textAlignment = .right
        return label
    }
    
    private func getRightButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.rightChevron(), for: .normal)
        button.imageView?.tintColor = R.color.foodViewing.basicPrimary()
        button.isEnabled = false
        return button
    }
}
