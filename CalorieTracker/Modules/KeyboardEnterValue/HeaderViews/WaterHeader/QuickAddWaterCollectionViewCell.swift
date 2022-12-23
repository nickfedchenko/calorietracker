//
//  QuickAddWaterCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.12.2022.
//

import UIKit

final class QuickAddWaterCollectionViewCell: UICollectionViewCell {
    
    var type: TypeQuickAdd? {
        didSet {
            view.type = type
        }
    }
    
    var isSelectedCell: Bool = false {
        didSet {
            view.isSelected = isSelectedCell
        }
    }
    
    private lazy var view = QuickAddWaterView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    private func setupConstraints() {
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

