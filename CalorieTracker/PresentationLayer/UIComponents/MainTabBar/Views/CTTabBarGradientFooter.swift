//
//  CTTabBarGradientFooter.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 26.12.2022.
//

import UIKit

final class CTTabBarGradientFooter: UIView {
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGradient()
    }
    
    private func drawGradient() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor(hex: "F3FFFE", alpha: 0.9).cgColor, UIColor(hex: "F3FFFE", alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.5, 1]
    }
}
