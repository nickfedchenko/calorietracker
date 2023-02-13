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
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: mainWidgetNode.constants.height)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultHigh
        )
        return layoutAttributes
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
