//
//  SecondPageFormView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import UIKit

final class SecondPageFormView: UIView, UIGestureRecognizerDelegate {
    private lazy var servingSizeLabel: UILabel = getServingSizeLabel()
    private lazy var servingWeightLabel: UILabel = getServingWeightLabel()
    private lazy var selectView: SelectView = getSelectView()
    private lazy var valueTextField: UITextField = getValueTextField()
    
    private lazy var hideGesture: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(closeMenu)
    )

    private lazy var servingSizeForm: FormView = getServingSizeForm()
    
    var title: String? { servingSizeForm.value }
    var weight: Double? {
        guard let valueStr = valueTextField.text else {
            return nil
        }
        let cleanValue = valueStr.replacingOccurrences(of: ",", with: ".")
        guard let value = Double(cleanValue) else { return nil }
        return value
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        setupHandlers()
        hideGesture.delegate = self
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
    
    private func setupHandlers() {
        selectView.didShowHandler = { [weak self] in
            guard let self = self else { return }
            self.superview?.removeGestureRecognizer(self.hideGesture)
            self.superview?.addGestureRecognizer(self.hideGesture)
        }
        
        selectView.didSelectedCell = { [weak self] _, _ in
            guard let self = self else { return }
            self.superview?.removeGestureRecognizer(self.hideGesture)
        }
    }
    
    @objc private func closeMenu(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if !selectView.frame.contains(location) {
            selectView.collapse()
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self)
        let shouldBegin = !selectView.isCollapsed && !selectView.frame.contains(location)
        return shouldBegin
    }
}

// MARK: - Factory

extension SecondPageFormView {
    
    private func getServingSizeTitle() -> String {
        if let title = title {
            guard !title.isEmpty else {
                let size = selectView.selectedCellType?.getTitle(.long) ?? ""
                return size
            }
            return title
        } else {
            return selectView.selectedCellType?.getTitle(.long) ?? ""
        }
    }
    
    private func getServingWeightLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.foodViewing.basicGrey()
        label.text = R.string.localizable.createFormServingWeight()
        return label
    }
    
    private func getServingSizeLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.foodViewing.basicGrey()
        label.text = R.string.localizable.createFormServingDescription()
        return label
    }
    
    private func getServingSizeForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .optional)
        return form
    }
        
    func getSelectView() -> SelectView<FoodViewingWeightType> {
        SelectView(FoodViewingWeightType.allCases, shouldHideAtStartup: true)
    }
    
    func getValueTextField() -> InnerShadowTextField {
        let textField = InnerShadowTextField()
        textField.innerShadowColors = [R.color.foodViewing.basicSecondaryDark() ?? .clear]
        textField.layer.borderWidth = 1
        textField.layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.keyboardAppearance = .light
        textField.text = "100"
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
                radius: 2,
                spread: 0
            ),
            Shadow(
                color: R.color.createProduct.formSecondShadow() ?? .black,
                opacity: 0.1,
                offset: CGSize(width: 0, height: 4),
                radius: 10,
                spread: 0
            )
        ]
    }
}
