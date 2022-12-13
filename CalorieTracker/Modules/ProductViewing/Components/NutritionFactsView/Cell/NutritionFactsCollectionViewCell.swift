//
//  NutritionFactsCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.11.2022.
//

import UIKit

final class NutritionFactsCollectionViewCell: UICollectionViewCell {
    var viewModel: NutritionFactsCellVM! {
        didSet {
            configureView()
        }
    }
    
    private let view = NutritionFactsCellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        view.viewModel = viewModel
    }
    
    private func setupConstraints() {
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
