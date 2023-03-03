//
//  SettingsCategoryCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 15.12.2022.
//

import UIKit

final class SettingsCategoryCollectionViewCell: UICollectionViewCell {
    
    var type: SettingsCategoryType?
    var viewModel: SettingsCategoryCellViewModel? {
        didSet {
            view.viewModel = viewModel
        }
    }
    
    var cellState: SettingsCategoryViewState = .default {
        didSet {
            view.state = cellState
            didChangeState()
        }
    }
    
    private lazy var view: SettingsCategoryView = .init(frame: .zero)
    private lazy var shadowView: ViewWithShadow = .init(Const.shadows)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didChangeState() {
        switch cellState {
        case .isSelected:
            shadowView.isHidden = true
            view.layer.borderWidth = 2
        default:
            shadowView.isHidden = false
            view.layer.borderWidth = 0
        }
    }
    
    private func setupView() {
        shadowView.layer.cornerRadius = 16
        view.layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
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

extension SettingsCategoryCollectionViewCell {
    struct Const {
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
}
