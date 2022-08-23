//
//  CTAddFolderButton.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 19.08.2022.
//

import UIKit

final class CTAddFolderButton: UIButton {
    private var isFirstLayout = true
    
    var shadowLayer = CAShapeLayer()
    var shapeLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupAppearance()
        setupImage()
     
    }
    
    private func setupAppearance() {
        guard let layer = layer as? CAShapeLayer else { return }
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 8)
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor(hex: "06BBBB").cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowColor = UIColor(hex: "123E5E").cgColor
        shadowLayer.shadowOpacity = 0.15
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.insertSublayer(shadowLayer, at: 0)
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(hex: "62D3B4").cgColor
        layer.insertSublayer(shapeLayer, at: 1)
        isFirstLayout = false
    }
    
    private func setupImage() {
        setImage(R.image.addFolderIcon(), for: .normal)
        tintColor = .white
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
}
