//
//  InnerShadowTextField.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.11.2022.
//

import UIKit

class InnerShadowTextField: UITextField {
    
    var innerShadowColor: UIColor? {
        get { UIColor(cgColor: innerShadowLayer.shadowColor ?? UIColor.clear.cgColor) }
        set { innerShadowLayer.shadowColor = newValue?.cgColor }
    }
    
    private let innerShadowLayer = CALayer()
    private var isFirstDraw = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        innerShadowLayer.shadowOpacity = 1
        innerShadowLayer.shadowRadius = 2
        innerShadowLayer.masksToBounds = true
        layer.addSublayer(innerShadowLayer)
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
        innerShadowLayer.frame = bounds
        innerShadowLayer.shadowPath = getShadowPath(rect: bounds).cgPath
        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        innerShadowLayer.shadowColor = innerShadowColor?.cgColor
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
