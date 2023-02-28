//
//  GradientUndercover.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.02.2023.
//

import UIKit

final class GradientUndercover: UIView {
    
    private var colors: [CGColor]
    private let axis: GradientLayer.Axis
    private let locations: [NSNumber]
    
    private var gradientLayer = CAGradientLayer()
    
    init(with colors: [UIColor], axis: GradientLayer.Axis, locations: [NSNumber]) {
        self.colors = colors.compactMap { $0.cgColor }
        self.axis = axis
        self.locations = locations
        super.init(frame: .zero)
        layer.addSublayer(gradientLayer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawGradient() {
       gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = axis.getPoints().start
        gradientLayer.endPoint = axis.getPoints().end
    }
}
