//
//  SettingsUnitsCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

final class SettingsUnitsCollectionViewCell: UICollectionViewCell {
    
    var didChangeUnits: ((Units) -> Void)?
    var viewModel: SettingsUnitsCellViewModel? {
        didSet {
            view.viewModel = viewModel
        }
    }
    
    private lazy var view: SettingsUnitsView = .init(frame: .zero)
    
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
        
        view.didChangeUnits = { units in
            self.didChangeUnits?(units)
        }
    }
    
    private func setupConstraints() {
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
