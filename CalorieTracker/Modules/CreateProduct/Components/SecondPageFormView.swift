//
//  SecondPageFormView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import UIKit

final class SecondPageFormView: UIView {
    private lazy var servingSizeLabel: UILabel = getServingSizeLabel()
    private lazy var servingWeightLabel: UILabel = getServingWeightLabel()
    private lazy var selectView: SelectView = getSelectView()
    private lazy var valueTextField: UITextField = getValueTextField()

    private lazy var servingSizeForm: FormView = getServingSizeForm()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubviews(
            servingSizeLabel,
            servingSizeForm,
            servingWeightLabel,
            valueTextField,
            selectView
        )
    }
    
    private func setupConstraints() {
        servingSizeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview()
        }
        
        servingSizeForm.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(servingSizeLabel.snp.bottom).offset(4)
            make.height.equalTo(48)
        }
        
        servingWeightLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(servingSizeForm.snp.bottom).offset(16)
        }
        
        valueTextField.aspectRatio(0.727)
        valueTextField.snp.makeConstraints { make in
            make.top.equalTo(servingWeightLabel.snp.bottom).offset(4)
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(64)
        }
        
        selectView.height = 64
        selectView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.leading.equalTo(valueTextField.snp.trailing).offset(12)
        }
    }
}

// MARK: - Factory

extension SecondPageFormView {
    private func getServingWeightLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.foodViewing.basicGrey()
        label.text = "Serving weight"
        return label
    }
    
    private func getServingSizeLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.foodViewing.basicGrey()
        label.text = "Serving size description"
        return label
    }
    
    private func getServingSizeForm() -> FormView {
        let form = FormView()
        form.model = .init(type: nil, width: .large, value: .optional)
        return form
    }
        
    func getSelectView() -> SelectView<FoodViewingWeightType> {
        SelectView(FoodViewingWeightType.allCases)
    }
    
    func getValueTextField() -> InnerShadowTextField {
        let textField = InnerShadowTextField()
        textField.innerShadowColor = R.color.foodViewing.basicSecondaryDark()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.keyboardAppearance = .light
        return textField
    }
}

extension SecondPageFormView {
    private struct Const {
        static let shadows: [Shadow] = [
            Shadow(
                color: R.color.createProduct.formFirstShadow() ?? .black,
                opacity: 0.15,
                offset: CGSize(width: 0, height: 0.5),
                radius: 2
            ),
            Shadow(
                color: R.color.createProduct.formSecondShadow() ?? .black,
                opacity: 0.1,
                offset: CGSize(width: 0, height: 4),
                radius: 10
            )
        ]
    }
}
