//
//  MainWidgetCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.02.2023.
//

import UIKit

class MainWidgetCollectionViewCell: UICollectionViewCell {
    private lazy var mainWidgetNode = MainWidgetViewNode(with: .init(type: .widget))
    
    private var mainWidgetView: UIView {
        return mainWidgetNode.view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: MainWidgetViewNode.Model) {
        mainWidgetNode.model = model
    }
    
    private func setupView() {
        
    }
    
    private func setupConstraints() {
        contentView.addSubview(mainWidgetView)
        
        mainWidgetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(mainWidgetNode.constants.height)
        }
    }
}
