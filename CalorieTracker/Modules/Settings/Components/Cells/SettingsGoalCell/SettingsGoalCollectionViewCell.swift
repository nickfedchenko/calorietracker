//
//  SettingsGoalCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import UIKit

final class SettingsGoalCollectionViewCell: UICollectionViewCell {
    
    var viewModel: SettingsGoalCellViewModel? {
        didSet {
            view.viewModel = viewModel
        }
    }
    
    private lazy var view: SettingsGoalView = .init(frame: .zero)
    private lazy var shadowView: ViewWithShadow = .init(Const.shadows)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        shadowView.layer.cornerRadius = 16
    }
    
    private func setupConstraints() {
        contentView.addSubviews(shadowView, view)
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SettingsGoalCollectionViewCell {
    struct Const {
        static let shadows: [Shadow] = [
            Shadow(
                color: R.color.createProduct.formFirstShadow() ?? .black,
                opacity: 0.15,
                offset: CGSize(width: 0, height: 0.5),
                radius: 2
            ),
            Shadow(
                color: R.color.createProduct.formSecondShadow() ?? .black,
                opacity: 0.1,
                offset: CGSize(width: 0, height: 4),
                radius: 10
            )
        ]
    }
}
