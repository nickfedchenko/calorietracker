//
//  SettingsProfileTextFieldCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.12.2022.
//

import UIKit

final class SettingsProfileTextFieldCollectionViewCell: UICollectionViewCell {
    
    var type: ProfileSettingsCategoryType?
    var viewModel: SettingsProfileTextFieldViewModel? {
        didSet {
            view.viewModel = viewModel
        }
    }
    
    var text: String? {
        get { view.text }
        set { view.text = newValue }
    }
    
    private lazy var view: SettingsProfileTextFieldView = .init(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubviews(view)

        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
