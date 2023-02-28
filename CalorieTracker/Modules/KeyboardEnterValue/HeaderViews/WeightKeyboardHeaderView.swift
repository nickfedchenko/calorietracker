//
//  WeightKeyboardHeaderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.12.2022.
//

import UIKit

final class WeightKeyboardHeaderView: UIView, KeyboardHeaderProtocol {
    enum ActionType {
        case add
        case set
    }
    
    private lazy var gradientBackgroundView: UIView = getGradientBackgroundView()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var imageView: UIImageView = getImageView()
    private lazy var textField: UITextField = getTextField()
    private lazy var saveButton: BasicButtonView = .init(type: .save)
    
    private var firstDraw = true
    
    private var imageViewScale: CGFloat {
        switch actionType {
        case .add:
            return 0.27
        case .set:
            return 0.44
        }
    }
    
    private var titleSpasing: CGFloat {
        switch actionType {
        case .add:
            return 23
        case .set:
            return 48
        }
    }
    
    var didTapClose: (() -> Void)?
    var didChangeValue: ((Double) -> Void)?
    
    let actionType: ActionType
    
    init(_ type: ActionType) {
        self.actionType = type
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
        
        titleLabel.text = {
            switch actionType {
            case .add:
                return R.string.localizable.keyboardWeightTitleAdd()
            case .set:
                return R.string.localizable.keyboardWeightTitleSet()
            }
        }()
        
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
            make.width.equalToSuperview().multipliedBy(imageViewScale)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(imageView.snp.bottom).offset(titleSpasing)
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

extension WeightKeyboardHeaderView {
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
        label.textColor = R.color.keyboardHeader.weightDarkGreen()
        label.textAlignment = .center
        return label
    }
    
    private func getImageView() -> UIImageView {
        let view = UIImageView()
        view.image = {
            switch actionType {
            case .add:
                return R.image.keyboardHeader.weightSecond()
            case .set:
                return R.image.keyboardHeader.weightFirst()
            }
        }()
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
        textField.textColor = R.color.keyboardHeader.weightDarkGreen()
        textField.tintColor = R.color.keyboardHeader.weightGreen()
        textField.textAlignment = .center
        textField.clipsToBounds = true
        return textField
    }
}

extension WeightKeyboardHeaderView {
    private struct Const {
        static let gradientColors = [
            R.color.keyboardHeader.topGradient(),
            R.color.keyboardHeader.bottomGradient()
        ]
    }
}
