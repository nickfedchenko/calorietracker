//
//  StepsKeyboardHeaderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.12.2022.
//

import UIKit

final class StepsKeyboardHeaderView: UIView, KeyboardHeaderProtocol {
    private lazy var gradientBackgroundView: UIView = getGradientBackgroundView()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var imageView: UIImageView = getImageView()
    private lazy var textField: UITextField = getTextField()
    private lazy var saveButton: BasicButtonView = .init(type: .save)
    
    private var firstDraw = true
    
    var didTapClose: (() -> Void)?
    var didChangeValue: ((Double) -> Void)?
    
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
        guard firstDraw else { return }
        setupGradient()
        firstDraw = false
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 36
        layer.maskedCorners = .topCorners
        
        layer.masksToBounds = true
        
        titleLabel.text = R.string.localizable.keyboardStepsTitle()
        
        saveButton.addTarget(
            self,
            action: #selector(didTapSaveButton),
            for: .touchUpInside
        )
    }
    
    private func setupConstraints() {
        addSubview(gradientBackgroundView)
        gradientBackgroundView.addSubviews(
            closeButton,
            imageView,
            titleLabel,
            textField,
            saveButton
        )
        
        gradientBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.top.equalToSuperview().offset(21)
        }
        
        imageView.aspectRatio()
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(closeButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(imageView.snp.bottom).offset(40)
        }
        
        textField.aspectRatio(0.26)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.width.equalToSuperview().multipliedBy(0.59)
            make.centerX.equalToSuperview()
        }
        
        saveButton.aspectRatio(0.171)
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom).offset(26)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setupGradient() {
        let gradientLayer = GradientLayer(.init(
                bounds: bounds,
                colors: Const.gradientColors,
                axis: .vertical(.top),
                locations: [0, 1]
        ))
        
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc private func didTapCloseButton() {
        self.didTapClose?()
    }
    
    @objc private func didTapSaveButton() {
        if let text = textField.text, let value = Double(text) {
            self.didChangeValue?(value)
        }
        self.didTapClose?()
    }
}

// MARK: - Factory

extension StepsKeyboardHeaderView {
    private func getGradientBackgroundView() -> UIView {
        let view = UIView()
        return view
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.keyboardHeader.weightClose(), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCloseButton),
            for: .touchUpInside
        )
        return button
    }
    
    private func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextRegular(size: 28.fontScale())
        label.textColor = R.color.keyboardHeader.purpleDark()
        label.textAlignment = .center
        return label
    }
    
    private func getImageView() -> UIImageView {
        let view = UIImageView()
        view.image = R.image.keyboardHeader.weightFirst()
        return view
    }
    
    private func getTextField() -> UITextField {
        let textField = InnerShadowTextField()
        textField.innerShadowColor = R.color.keyboardHeader.topGradient()
        textField.backgroundColor = .white
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 16
        textField.keyboardType = .decimalPad
        textField.keyboardAppearance = .light
        textField.font = R.font.sfProDisplaySemibold(size: 28)
        textField.textColor = R.color.keyboardHeader.purpleDark()
        textField.tintColor = R.color.keyboardHeader.purple()
        textField.textAlignment = .center
        textField.clipsToBounds = true
        return textField
    }
}

extension StepsKeyboardHeaderView {
    private struct Const {
        static let gradientColors = [
            R.color.keyboardHeader.topGradient(),
            R.color.keyboardHeader.bottomGradient()
        ]
    }
}
