//
//  SettingsNutrientGoalCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.12.2022.
//

import UIKit

final class SettingsNutrientGoalCollectionViewCell: UICollectionViewCell {
    
    var viewModel: SettingsNutrientGoalCellViewModel? {
        didSet {
            view.viewModel = viewModel
            view.viewModel?.output = view
        }
    }
    
    var didChangePercent: ((Float) -> Void)?
    
    private lazy var view: SettingsNutrientGoalView = .init(frame: .zero)
    
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
        
        view.didChangePercent = { value in
            self.didChangePercent?(value)
        }
    }
    
    private func setupConstraints() {
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
