//
//  FormCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import UIKit

final class FormCollectionViewCell<T: WithGetTitleProtocol>: UICollectionViewCell {
    private let formView = FormView<T>()
    
    var model: FormModel<T>? {
        didSet {
            formView.model = model
        }
    }
    
    var value: String? {
        get {
            guard let value = formView.value, !value.isEmpty else {
                return nil
            }
            return value
        }
        set { formView.value = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(formView)
        
        formView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
