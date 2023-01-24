//
//  EstimationSmileButton.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.01.2023.
//

import UIKit

final class EstimationSmileButton: UIControl {
    private lazy var imageView: UIImageView = .init(frame: .zero)
    
    let type: Estimation
    
    var isSelectedSmile = false {
        didSet {
            didChangeSelected()
        }
    }
    
    init(_ type: Estimation) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        didChangeSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
    }
    
    private func setupView() {
        layer.cornerCurve = .circular
        layer.borderColor = UIColor.white.cgColor
        imageView.image = type.getEstimationSmile()
    }
    
    private func setupConstraints() {
        addSubview(imageView)
        
        self.aspectRatio()
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func didChangeSelected() {
        switch isSelectedSmile {
        case true:
            layer.opacity = 1
            layer.borderWidth = 3
        case false:
            layer.opacity = 0.3
            layer.borderWidth = 0
        }
    }
}
