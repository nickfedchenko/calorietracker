//
//  QuickAddWaterView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.12.2022.
//

import UIKit

final class QuickAddWaterView: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()

    var type: TypeQuickAdd? {
        didSet {
            didChangeType()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            didChangeSelectCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        didChangeSelectCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        addSubviews(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func didChangeType() {
        imageView.image = type?.getImage()
    }
    
    private func didChangeSelectCell() {
        switch isSelected {
        case true:
            layer.borderColor = R.color.keyboardHeader.waterPrimary()?.cgColor
            layer.borderWidth = 3
            imageView.backgroundColor = .white
        case false:
            layer.borderColor = R.color.keyboardHeader.waterBG()?.cgColor
            layer.borderWidth = 1
            imageView.backgroundColor = R.color.keyboardHeader.waterBackground()
        }
    }
}
