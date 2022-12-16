//
//  SettingsCategoryView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 15.12.2022.
//

import UIKit

final class SettingsCategoryView: UIView {
    var viewModel: SettingsCategoryCellViewModel? {
        didSet {
            updateViewModel()
        }
    }
    
    private lazy var leftImageView: UIImageView = getLeftImageView()
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var descriptionLabel: UILabel = getDescriptionLabel()
    private lazy var textStackView: UIStackView = getTextStackView()
    private lazy var rightButton: UIButton = getRightButton()
    private lazy var remindersCountLabel: UILabel = getRemindersCountLabel()
    private lazy var remindersCountBackgroundView: UIView = getRemindersCountBackgroundView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        remindersCountBackgroundView.layer.cornerRadius = remindersCountBackgroundView.frame.height / 2.0
    }
    
    private func updateViewModel() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.titleColor
        
        leftImageView.image = viewModel.image
        leftImageView.backgroundColor = viewModel.imageBackgroundColor
        
        if let description = viewModel.description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
            descriptionLabel.textColor = viewModel.descriptionColor
        } else {
            descriptionLabel.isHidden = true
        }
        
        if viewModel.remindersCount > 0 {
            remindersCountBackgroundView.isHidden = false
            remindersCountLabel.text = "\(viewModel.remindersCount)"
        } else {
            remindersCountBackgroundView.isHidden = true
        }
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        backgroundColor = .white
    }
    
    private func setupConstraints() {
        addSubviews(
            leftImageView,
            textStackView,
            remindersCountBackgroundView,
            rightButton
        )
        
        textStackView.addArrangedSubviews(
            titleLabel,
            descriptionLabel
        )
        
        remindersCountBackgroundView.addSubview(remindersCountLabel)
        
        leftImageView.aspectRatio()
        leftImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        textStackView.snp.makeConstraints { make in
            make.bottom.top.equalTo(leftImageView)
            make.leading.equalTo(leftImageView.snp.trailing).offset(14)
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.height.width.equalTo(24)
            make.bottom.top.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
        
        remindersCountLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
            make.leading.trailing.equalToSuperview().inset(6)
        }
        
        remindersCountBackgroundView.snp.makeConstraints { make in
            make.trailing.equalTo(rightButton.snp.leading).offset(-14)
            make.leading.equalTo(textStackView.snp.trailing).offset(14)
            make.top.bottom.greaterThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Factory

extension SettingsCategoryView {
    private func getLeftImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 8
        view.contentMode = .center
        return view
    }
    
    private func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        return label
    }
    
    private func getDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 12)
        return label
    }
    
    private func getTextStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }
    
    private func getRightButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.rightChevron(), for: .normal)
        button.imageView?.tintColor = R.color.foodViewing.basicPrimary()
        button.isEnabled = false
        return button
    }
    
    private func getRemindersCountLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 12)
        label.textColor = .white
        return label
    }
    
    private func getRemindersCountBackgroundView() -> UIView {
        let view = UIView()
        layer.cornerCurve = .circular
        return view
    }
}
