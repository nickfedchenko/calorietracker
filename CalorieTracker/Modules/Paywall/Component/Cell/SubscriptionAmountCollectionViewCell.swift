//
//  SubscriptionAmountCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.12.2022.
//

import UIKit

final class SubscriptionAmountCollectionViewCell: UICollectionViewCell {
    
    private let view = SubscriptionAmount()
    
    var isSelectedCell: Bool = false {
        didSet {
            view.isSelected = isSelectedCell
        }
    }
    override var isSelected: Bool {
        didSet {
            isSelectedCell = isSelected
        }
    }
    
    var model: SubscriptionAmountModel? {
        didSet {
            view.model = model
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
