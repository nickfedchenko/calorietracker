//
//  GradientNode.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 21.02.2023.
//

import AsyncDisplayKit

final class GradientNode: ASDisplayNode {
    private let gradientLayer = CAGradientLayer()
    
    override init() {
        super.init()
        backgroundColor = .clear
        automaticallyManagesSubnodes = true
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.zPosition = -1
    }
    
    override func layoutDidFinish() {
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(hex: "F3FFFE").withAlphaComponent(0.9).cgColor,
            UIColor(hex: "F3FFFE").withAlphaComponent(0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.locations = [0.95, 1]
    }
}
