//
//  MealKeyboardHeaderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

final class MealKeyboardHeaderView: UIView, KeyboardHeaderProtocol {
    private lazy var gradientBackgroundView: UIView = getGradientBackgroundView()
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var textField: UITextField = getTextField()
    private lazy var saveButton: BasicButtonView = .init(type: .save)
    
    private var firstDraw = true
    
    private let title: String
    
    var didTapClose: (() -> Void)?
    var didChangeValue: ((Double) -> Void)?
    
    private var complition: ((String) -> String)?
    
    init(_ title: String, complition: ((String) -> String)?) {
        self.title = title
        self.complition = complition
        super.init(frame: .zero)
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
        
        titleLabel.text = title
        
        saveButton.addTarget(
            self,
            action: #selector(didTapSaveButton),
            for: .touchUpInside
        )
        
        textField.addTarget(self, action: #selector(didChangeValueTextField), for: .editingChanged)
    }
    
    private func setupConstraints() {
        addSubview(gradientBackgroundView)
        gradientBackgroundView.addSubviews(
            titleLabel,
            textField,
            saveButton
        )
        
        gradientBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().offset(39)
        }
        
        textField.aspectRatio(0.171)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        saveButton.aspectRatio(0.171)
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom).offset(18)
            make.bottom.equalToSuperview().offset(-18)
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
    
    @objc private func didChangeValueTextField() {
        guard let description = complition?(textField.text ?? ""), !description.isEmpty else {
            titleLabel.attributedText = nil
            titleLabel.text = title
            return
        }
        let str = "\(title) (\(description))"
        let font = R.font.sfProDisplaySemibold(size: 22.fontScale())
        titleLabel.attributedText = str.attributedSring([
            .init(
                worldIndex: [0],
                attributes: [
                    .font(font),
                    .color(R.color.foodViewing.basicDark())
                ]
            ),
            .init(
                worldIndex: Array(1...str.split(separator: " ").count),
                attributes: [
                    .font(font),
                    .color(R.color.foodViewing.basicDarkGrey())
                ]
            )
        ])
    }
}

// MARK: - Factory

extension MealKeyboardHeaderView {
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
        label.font = R.font.sfProDisplaySemibold(size: 22.fontScale())
        label.textColor = R.color.foodViewing.basicDark()
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
        textField.innerShadowColors = [R.color.keyboardHeader.topGradient() ?? .clear]
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

extension MealKeyboardHeaderView {
    private struct Const {
        static let gradientColors = [
            R.color.keyboardHeader.topGradient(),
            R.color.keyboardHeader.bottomGradient()
        ]
    }
}
