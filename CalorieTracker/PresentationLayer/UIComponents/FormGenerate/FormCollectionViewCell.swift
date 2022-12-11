//
//  FormCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import UIKit

final class FormCollectionViewCell: UICollectionViewCell {
    private let formView = FormView()
    
    var model: FormModel? {
        didSet {
            formView.model = model
        }
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
