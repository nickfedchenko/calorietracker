//
//  InnerShadowTextField.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.11.2022.
//

import UIKit

class InnerShadowTextField: UITextField {
    
    var innerShadowColors: [UIColor] {
        get {
            [
                UIColor(cgColor: innerShadowFirstLayer.shadowColor ?? UIColor.clear.cgColor),
                UIColor(cgColor: innerShadowSecondLayer.shadowColor ?? UIColor.clear.cgColor)
            ]
        }
        set {
            guard newValue.count > 1 else {
                innerShadowFirstLayer.shadowColor = UIColor.clear.cgColor
                innerShadowSecondLayer.shadowColor = UIColor.clear.cgColor
                return
            }
            innerShadowFirstLayer.shadowColor = newValue[0].cgColor
            innerShadowSecondLayer.shadowColor = newValue[1].cgColor
        }
    }
    
    private let innerShadowFirstLayer = CALayer()
    private let innerShadowSecondLayer = CALayer()
    private var isFirstDraw = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(innerShadowSecondLayer)
        layer.addSublayer(innerShadowFirstLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard isFirstDraw else { return }
        textFieldInnerShadow()
        isFirstDraw = false
    }
    
    private func textFieldInnerShadow() {
        innerShadowFirstLayer.frame = bounds
        innerShadowFirstLayer.shadowPath = getShadowPath(rect: bounds).cgPath
        innerShadowFirstLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        innerShadowFirstLayer.shadowOpacity = 0.35
        innerShadowFirstLayer.shadowRadius = 2
        innerShadowFirstLayer.shadowColor = innerShadowColors[0].cgColor
        innerShadowSecondLayer.frame = bounds
        innerShadowSecondLayer.shadowPath = getShadowPath(rect: bounds).cgPath
        innerShadowSecondLayer.shadowOffset = CGSize(width: 0, height: 1)
        innerShadowSecondLayer.shadowOpacity = 0.05
        innerShadowSecondLayer.shadowRadius = 16
        innerShadowSecondLayer.shadowColor = innerShadowColors[1].cgColor
    }
    
    private func getShadowPath(rect: CGRect) -> UIBezierPath {
        let radius = layer.cornerRadius
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: -radius / 2.0, dy: -radius / 2.0), cornerRadius: radius)
//        let path = UIBezierPath(
//            roundedRect: rect.insetBy(dx: -radius / 2.0, dy: -radius / 2.0),
//            cornerRadius: layer.cornerRadius
//        )
        
        let innerPart = UIBezierPath(
            roundedRect: rect,
            cornerRadius: radius
        ).reversing()
        path.append(innerPart)
        
        return path
    }
}
