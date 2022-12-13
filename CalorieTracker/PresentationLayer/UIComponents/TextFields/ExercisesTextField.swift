//
//  ExercisesTextField.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 17.08.2022.
//

import UIKit

final class ExercisesTextField: UITextField {
    enum Style {
        case empty
        case notEmpty
        case entry
        case error
        case autoFill
    }
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 15)
        label.textColor = R.color.exercisesTextField.plaseholder()
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 15)
        label.textColor = R.color.exercisesTextField.plaseholder()
        return label
    }()
    
    var leftTitle: String? {
        get { leftLabel.text }
        set { leftLabel.text = newValue }
    }
    
    var rightTitle: String? {
        get { rightLabel.text }
        set { rightLabel.text = newValue }
    }
    
    var style: Style = .empty {
        didSet {
            didChangeStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        didChangeStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        font = R.font.sfProDisplaySemibold(size: 22)
        textColor = R.color.exercisesTextField.textEntry()
        tintColor = R.color.exercisesTextField.borderEntry()
        
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        
        leftViewMode = .always
        rightViewMode = .always
        textAlignment = .right
        
        delegate = self
        
        let leftView = UIView()
        leftView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-1)
        }
        
        let rightView = UIView()
        rightView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.leftView = leftView
        self.rightView = rightView
    }
    
    private func didChangeStyle() {
        switch style {
        case .empty:
            layer.borderColor = R.color.exercisesTextField.borderEmpty()?.cgColor
            backgroundColor = R.color.exercisesTextField.backgroundEmpty()
        case .notEmpty:
            layer.borderColor = R.color.exercisesTextField.borderEmpty()?.cgColor
            backgroundColor = .white
        case .entry:
            layer.borderColor = R.color.exercisesTextField.borderEntry()?.cgColor
            backgroundColor = .white
        case .error:
            layer.borderColor = R.color.exercisesTextField.errorBorder()?.cgColor
            backgroundColor = R.color.exercisesTextField.backgroundError()
        case .autoFill:
            layer.borderColor = R.color.exercisesTextField.borderEmpty()?.cgColor
            backgroundColor = R.color.exercisesTextField.backgroundAutoFill()
        }
    }
}

extension ExercisesTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        style = .entry
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        style = textField.text?.isEmpty == true ? .empty : .notEmpty
    }
}
