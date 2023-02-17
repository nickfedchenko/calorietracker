//
//  AddCustomEntryButton.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 16.02.2023.
//

import UIKit

enum ButtonState {
    case active
    case inactive
}

class AddCustomEntryButton: UIButton {
    
    private let buttonImage: UIImage? = R.image.basicButton.addDefault()
    private let buttonImagePressed: UIImage? = R.image.basicButton.addPressed()
    
    private lazy var firstShadowLayer: CALayer = {
        let layer = CALayer()
        layer.name = "firstShadowLayer"
        layer.shadowColor = R.color.addFood.menu.secondShadow()?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2
        return layer
    }()
    
    private lazy var secondShadowLayer: CALayer = {
        let layer = CALayer()
        layer.name = "secondShadowLayer"
        layer.shadowColor = R.color.addFood.menu.firstShadow()?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        return layer
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.name = "gradientLayer"
        
        guard let firstColor = R.color.basicButton.gradientFirstColor(),
              let secondColor = R.color.basicButton.gradientSecondColor()
        else { return gradient }
        
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setState(.active)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        self.snp.makeConstraints { make in
            make.width.equalTo(374)
            make.height.equalTo(64)
        }
    }
    
    @objc func buttonTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
            self.setImage(self.buttonImagePressed, for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
                self.setImage(self.buttonImage, for: .normal)
            }
        })
    }
    
    func setState(_ state: ButtonState) {
        switch state {
        case .active:
            setImage(buttonImage, for: .normal)
            setImage(buttonImagePressed, for: .highlighted)
            
            layer.cornerRadius = 16
            layer.cornerCurve = .continuous
            layer.borderWidth = 2
            layer.borderColor = R.color.foodViewing.basicSecondary()?.cgColor
            
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
            firstShadowLayer.shadowPath = path
            secondShadowLayer.shadowPath = path
            
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.cornerCurve = layer.cornerCurve
            
            let layers = [firstShadowLayer, secondShadowLayer, gradientLayer]
            
            for index in 0..<layers.count {
                let layer = layers[index]
                guard self.layer.sublayers?.filter({ $0.name == layer.name }) != nil else { return }
                self.layer.insertSublayer(layer, at: UInt32(index))
            }
            
        case .inactive:
            backgroundColor = R.color.basicButton.inactiveColor()
            layer.borderColor = UIColor.white.cgColor
            setImage(buttonImage?.withTintColor(.white), for: .normal)
            
            layer.sublayers?.filter {
                ["firstShadowLayer", "secondShadowLayer", "gradientLayer"].contains($0.name)
            }.forEach { $0.removeFromSuperlayer() }
        }
    }
}
