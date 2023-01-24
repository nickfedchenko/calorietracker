//
//  RecipeMainGreenGradientButton.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.01.2023.
//

import UIKit

final class RecipeMainGreenGradientButton: UIButton {
    private let shapeLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let strokeLayer = CAShapeLayer()
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self.alpha = 0.9
//                    self.transform = .init(scaleX: 0.95, y: 0.9)
                    self.gradientLayer.colors = self.gradientLayer.colors?.reversed() ?? []
                }
            } else {
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self.alpha = 1
                    self.gradientLayer.colors = self.gradientLayer.colors?.reversed() ?? []
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawLayers()
    }
    
    private func placeLayers() {
        layer.insertSublayer(gradientLayer, at: 0)
        layer.insertSublayer(shapeLayer, at: 0)
        layer.insertSublayer(strokeLayer, at: 0)
    }
    
    private func drawLayers() {
//        clipsToBounds = true
//        shapeLayer.frame = bounds
        gradientLayer.frame = bounds
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        gradientLayer.colors = [UIColor(hex: "0C695E").cgColor, UIColor(hex: "004139").cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = shapeLayer
//        pathFor
        strokeLayer.path = path.cgPath
        strokeLayer.lineWidth = 3
        strokeLayer.strokeColor = UIColor(hex: "B3EFDE").cgColor
        
    }
    
}
