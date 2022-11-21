//
//  InnerShadowTextField.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.11.2022.
//

import UIKit

class InnerShadowTextField: UITextField {
    
    var innerShadowColor: UIColor?
    
    private var isFirstDraw = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard isFirstDraw else { return }
        textFieldInnerShadow()
        isFirstDraw = false
    }
    
    private func textFieldInnerShadow() {
        let innerShadowLayer = CALayer()
        innerShadowLayer.frame = bounds
        innerShadowLayer.shadowPath = getShadowPath(rect: bounds).cgPath
        innerShadowLayer.masksToBounds = true
        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        innerShadowLayer.shadowColor = innerShadowColor?.cgColor
        innerShadowLayer.shadowOpacity = 1
        innerShadowLayer.shadowRadius = 2
        layer.addSublayer(innerShadowLayer)
    }
    
    private func getShadowPath(rect: CGRect) -> UIBezierPath {
        let radius = layer.cornerRadius
        
        let path = UIBezierPath(
            roundedRect: rect.insetBy(dx: -radius / 2.0, dy: -radius / 2.0),
            cornerRadius: layer.cornerRadius
        )
        let innerPart = UIBezierPath(
            roundedRect: rect,
            cornerRadius: radius
        ).reversing()
        path.append(innerPart)
        
        return path
    }
}
