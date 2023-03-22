//
//  KcalKeyboardHeaderView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 05.03.2023.
//

import UIKit

protocol KcalKeyboardHeaderOutput: AnyObject {
    func didTapToRecalculate() -> Double?
    func didTapToSave(value: Double)
}

final class KcalKeyboardHeaderView: UIView, KeyboardHeaderProtocol {
    var didTapClose: (() -> Void)?
    var didChangeValue: ((Double) -> Void)?
    weak var output: KcalKeyboardHeaderOutput?
    
    private lazy var gradientBackgroundView: UIView = getGradientBackgroundView()
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var textField: UITextField = getTextField()
    private lazy var saveButton: BasicButtonView = getSaveButton()
    private lazy var recalculateButton = getRecalculateButton()
    private lazy var descriptionLabel = getDescriptionLabel()
    
    private var firstDraw = true
    
    private let title: String
    
    init(_ title: String) {
        self.title = title
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
      
    }
    
    private func setupConstraints() {
        addSubview(gradientBackgroundView)
        gradientBackgroundView.addSubviews(
            titleLabel,
            textField,
            descriptionLabel,
            saveButton,
            recalculateButton
        )
        
        gradientBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().offset(39)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(64)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom).offset(13)
        }
       
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(14)
            make.height.equalTo(64)
//            make.bottom.equalToSuperview().inset(18)
        }
        
        recalculateButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(saveButton)
            make.top.equalTo(saveButton.snp.bottom).offset(12)
            make.height.equalTo(64)
            make.bottom.equalToSuperview().inset(18)
        }
        
        saveButton.layoutIfNeeded()
        recalculateButton.layoutIfNeeded()

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
        if let text = textField.text {
            var formattedText = text.replacingOccurrences(of: " ", with: "")
            formattedText = formattedText.trimmingCharacters(in: .letters)
            
            if let value = Double(formattedText) {
                self.didChangeValue?(value)
//                self.didTapClose?()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.output?.didTapToSave(value: value)
                }
            }
        }
        
//        self.didTapClose?()
    }
    
    func setTextFieldFirstResponder() {
        textField.becomeFirstResponder()
    }
}

// MARK: - Factory

extension KcalKeyboardHeaderView {
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
        let textField = NonPastableTextField()
        textField.innerShadowColors = [R.color.keyboardHeader.topGradient() ?? .clear]
        textField.backgroundColor = .white
        textField.attributedPlaceholder = {
            let suffix = BAMeasurement.measurmentSuffix(.energy)
            let attrPlaceholder = getAttributesPlaceholder(from: suffix)
            return attrPlaceholder
        }()
        textField.addTarget(self, action: #selector(didChangeKcalValue(sender:)), for: .editingChanged)
        let suffix = BAMeasurement.measurmentSuffix(.energy)
        let currentKcal = Int(UDM.kcalGoal ?? 0)
        let kcalString = String(currentKcal)
        var attrNewText = NSMutableAttributedString(
            string: String(currentKcal) + " ",
            attributes: [
                .font: R.font.sfProRoundedBold(size: 28) ?? .systemFont(ofSize: 28),
                .foregroundColor: UIColor(hex: "0C695E"),
                .kern: 0.38
            ]
        )
        
        let placeholder = getAttributesPlaceholder(from: suffix)
        attrNewText.append(placeholder)
        textField.attributedText = attrNewText
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 16
        textField.keyboardType = .numberPad
        textField.keyboardAppearance = .light
        textField.textAlignment = .center
        textField.clipsToBounds = true
        
        textField.delegate = self
        return textField
    }
    
    private func getSaveButton() -> BasicButtonView {
        let button = BasicButtonView(type: .save)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }
    
    private func getAttributesPlaceholder(from string: String) -> NSAttributedString {
        let attrString = NSAttributedString(
            string: string,
            attributes: [
                .font: R.font.sfProRoundedMedium(size: 28) ?? .systemFont(ofSize: 28),
                .foregroundColor: UIColor(hex: "7A948F"),
                .kern: 0.38
            ]
        )
        return attrString
    }
    
    private func getRecalculateButton() -> BasicButtonView {
        let button = BasicButtonView(type: .custom(
            .init(
                image: .init(
                    isPressImage: R.image.settings.reset(),
                    defaultImage: R.image.settings.reset(),
                    inactiveImage: nil
                ),
                title: .init(
                    isPressTitleColor: R.color.foodViewing.basicPrimary(),
                    defaultTitleColor: R.color.foodViewing.basicPrimary()
                ),
                backgroundColorInactive: nil,
                backgroundColorDefault: R.color.foodViewing.basicSecondary(),
                backgroundColorPress: R.color.foodViewing.basicSecondaryDark(),
                gradientColors: nil,
                borderColorInactive: nil,
                borderColorDefault: R.color.foodViewing.basicSecondaryDark(),
                borderColorPress: R.color.foodViewing.basicSecondary()
            )
        ))
        button.defaultTitle = " \(R.string.localizable.settingsCalorieGoalRecalculate())"
        button.isPressTitle = " \(R.string.localizable.settingsCalorieGoalRecalculate())"
        button.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        return button
    }
    
    private func getDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = R.string.localizable.enterkcalHeaderviewDescription()
        return label
    }
    
    @objc private func didTapResetButton() {
        if let newValue = output?.didTapToRecalculate() {
            let suffix = BAMeasurement.measurmentSuffix(.energy)
            var newText = String(format: "%.0f", newValue)
            var attrNewText = NSMutableAttributedString(
                string: newText + " ",
                attributes: [
                    .font: R.font.sfProRoundedBold(size: 28) ?? .systemFont(ofSize: 28),
                    .foregroundColor: UIColor(hex: "0C695E"),
                    .kern: 0.38
                ]
            )
            let placeholder = getAttributesPlaceholder(from: suffix)
            attrNewText.append(placeholder)
            textField.attributedText = attrNewText
            if  let selectedRange = textField.selectedTextRange {
                if let newPosition = textField.position(from: selectedRange.start, offset: -suffix.count - 1) {
                    // set the new position
                    textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                }
            }
        }
    }
    
    @objc private func didChangeKcalValue(sender: UITextField) {
        guard let text = sender.text else { return }
        let suffix = BAMeasurement.measurmentSuffix(.energy)
     
        var newText = text.trimmingCharacters(in: .letters)
        newText = newText.replacingOccurrences(of: " ", with: "")
        var attrNewText = NSMutableAttributedString(
            string: newText + " ",
            attributes: [
                .font: R.font.sfProRoundedBold(size: 28) ?? .systemFont(ofSize: 28),
                .foregroundColor: UIColor(hex: "0C695E"),
                .kern: 0.38
            ]
        )
        let placeholder = getAttributesPlaceholder(from: suffix)
        attrNewText.append(placeholder)
        let selectedRange = sender.selectedTextRange
        sender.attributedText = attrNewText
        if let selectedRange = sender.selectedTextRange {

            // and only if the new position is valid
            if let newPosition = sender.position(from: selectedRange.start, offset: -suffix.count - 1) {
                // set the new position
                sender.selectedTextRange = sender.textRange(from: newPosition, to: newPosition)
            }
        }
    }
}

extension KcalKeyboardHeaderView {
    private struct Const {
        static let gradientColors = [
            R.color.keyboardHeader.topGradient(),
            R.color.keyboardHeader.bottomGradient()
        ]
    }
}

extension KcalKeyboardHeaderView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return true }
        let suffix = BAMeasurement.measurmentSuffix(.energy)
        var newText = text.replacingOccurrences(of: suffix, with: "")
        newText = newText.replacingOccurrences(of: " ", with: "") + string
        guard
            let value = Double(newText),
                value < 6000 else {
                    return false
                }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let suffix = BAMeasurement.measurmentSuffix(.energy)
        if let position = textField.position(from: textField.endOfDocument, offset: -suffix.count - 1) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
    }
}
