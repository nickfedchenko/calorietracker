//
//  RecipePageServingTextField.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 18.01.2023.
//

import UIKit

final class RecipePageServingTextField: UITextField {
    private let shadowLayer = CAShapeLayer()
    private let shapeLayer = CAShapeLayer()
    var filtersButtonTapAction: (() -> Void)?
    
    override var backgroundColor: UIColor? {
        get {
            UIColor(cgColor: shapeLayer.fillColor ?? UIColor.clear.cgColor)
        }
        
        set {
            shapeLayer.fillColor = newValue?.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        keyboardType = .decimalPad
        addDoneCancelToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawShadow()
    }
    
    private func setupAppearance() {
        layer.insertSublayer(shapeLayer, at: 0)
        layer.insertSublayer(shadowLayer, at: 0)
        backgroundColor = UIColor(hex: "FFFFFF")
        clipsToBounds = false
        font = R.font.sfProRoundedMedium(size: 24)
        textColor = UIColor(hex: "192621")
        text = "1"
        textAlignment = .center
    }
    
    private func drawShadow() {
        let shapeLayerShadowOpacity: Float = 0.2
        let shadowLayerOpacity: Float = 0.25
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
        shapeLayer.path = path.cgPath
        shapeLayer.shadowPath = path.cgPath
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor(hex: "62D3B4").cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 4)
        shapeLayer.shadowColor = UIColor(hex: "06BBBB").cgColor
        shapeLayer.shadowOpacity = shapeLayerShadowOpacity
        shapeLayer.shadowRadius = 10
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        shadowLayer.shadowColor = UIColor(hex: "123E5E").cgColor
        shadowLayer.shadowOpacity = shadowLayerOpacity
        shadowLayer.shadowRadius = 2
    }
}
