//
//  FormView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import UIKit

final class FormView<T: WithGetTitleProtocol>: ViewWithShadow, UITextFieldDelegate {
    private enum FormEditingState {
        case begin
        case end
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.tintColor = R.color.foodViewing.basicPrimary()
        textField.textColor = R.color.foodViewing.basicPrimary()
        textField.delegate = self
        return textField
    }()
    
    private var editingState: FormEditingState = .end {
        didSet {
            didChangeState()
        }
    }
    
    var model: FormModel<T>? {
        didSet {
            didChangeModel()
        }
    }
    
    var value: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    override init(_ shadows: [Shadow] = Const.shadows) {
        super.init(shadows)
        setupView()
        setupConstraints()
        setupTextFieldRightView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
        backgroundColor = .white
    }
    
    private func setupConstraints() {
        addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTextFieldLeftView() {
        guard let model = model else { return }
        
        let containerView = UIView()
        let label = UILabel()
        label.text = model.type.getTitle(.long)
        
        switch model.value {
        case .optional:
            label.font = R.font.sfProDisplaySemibold(size: 16)
            label.textColor = R.color.foodViewing.basicDarkGrey()
        case .required:
            label.font = R.font.sfProDisplaySemibold(size: 18)
            label.textColor = R.color.foodViewing.basicPrimary()
        }
        
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        textField.leftViewMode = .always
        textField.leftView = containerView
    }
    
    private func setupTextFieldRightView() {
        textField.setRightPaddingPoints(16)
    }
    
    private func didChangeModel() {
        guard let model = model else { return }
        if model.type is CreateProductViewController.ProductFormSegment {
            textField.keyboardType = .decimalPad
        }
        textField.placeholder = model.value.getTitle(.long)
        if model.type.getTitle(.long) != nil {
            textField.textAlignment = .right
            setupTextFieldLeftView()
        } else {
            textField.textAlignment = .left
            textField.setLeftPaddingPoints(16)
        }
        didChangeState()
    }
    
    private func didChangeState() {
        guard let model = model else { return }
        switch editingState {
        case .begin:
            layer.borderWidth = 1
            layer.borderColor = R.color.foodViewing.basicPrimary()?.cgColor
        case .end:
            switch model.value {
            case .optional:
                layer.borderWidth = 1
                layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
            case .required:
                layer.borderWidth = 2
                layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
            }
        }
    }
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        Vibration.selection.vibrate()
        self.editingState = .begin
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.editingState = .end
    }
}

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
