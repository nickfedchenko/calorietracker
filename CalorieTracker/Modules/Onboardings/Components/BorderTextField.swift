//
//  BorderTextField.swift
//  CalorieTracker
//
//  Created by Алексей on 26.08.2022.
//

import Foundation
import UIKit

final class BorderTextField: UIView {
    
    // MARK: - Public properties
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var isEnabled: Bool {
        get {
            return textField.isEnabled
        }
        set {
            textField.isEnabled = newValue
        }
    }
    
    // MARK: - Views properties

    let textField: UITextField = .init()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor
        layer.cornerRadius = 12
        
        textField.backgroundColor = .white
        textField.tintColor = R.color.onboardings.basicDark()
        textField.font = .systemFont(ofSize: 34, weight: .medium)
        textField.textColor = R.color.onboardings.basicDark()
        textField.textAlignment = .center
        textField.layer.masksToBounds = false
        textField.addTarget(self, action: #selector(didChangedTextField), for: .editingChanged)
    }
        
    private func configureLayouts() {
        addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.bottom.equalTo(snp.bottom)
        }
    }

    @objc private func didChangedTextField(_ sender: UITextField) {
        _ = sender.text?.isEmpty ?? false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
