//
//  CustomAddButton.swift
//  CalorieTracker
//
//  Created by Alexandru Jdanov on 16.02.2023.
//

import UIKit

enum ButtonState {
    case active
    case inactive
}

class CustomAddButton: UIButton {
    
    var buttonImage: UIImage?
    var buttonImagePressed: UIImage?
    var gradientFirstColor: UIColor?
    var gradientSecondColor: UIColor?
    var borderColorActive: UIColor?
    var bordeWidth: CGFloat?
    
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
        
        guard let firstColor = gradientFirstColor,
              let secondColor = gradientSecondColor
        else { return gradient }
        
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradient
    }()
    
    init(
        buttonImage: UIImage?,
        buttonImagePressed: UIImage?,
        gradientFirstColor: UIColor?,
        gradientSecondColor: UIColor?,
        borderColorActive: UIColor?,
        borderWidth: CGFloat?
    ) {
        self.buttonImage = buttonImage
        self.buttonImagePressed = buttonImagePressed
        self.gradientFirstColor = gradientFirstColor
        self.gradientSecondColor = gradientSecondColor
        self.borderColorActive = borderColorActive
        self.bordeWidth = borderWidth
        super.init(frame: .zero)
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
    
    private func addLayers() {
        let layers = [firstShadowLayer, secondShadowLayer, gradientLayer]
        
        for index in 0..<layers.count {
            let layer = layers[index]
            guard self.layer.sublayers?.filter({ $0.name == layer.name }) == nil else { return }
            self.layer.insertSublayer(layer, at: UInt32(index))
        }
    }
    
    private func addPath() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        firstShadowLayer.shadowPath = path
        secondShadowLayer.shadowPath = path
        gradientLayer.frame = bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addPath()
        addLayers()
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
            isUserInteractionEnabled = true
            
            self.layoutIfNeeded()
            setImage(buttonImage, for: .normal)
            setImage(buttonImagePressed, for: .highlighted)
            
            layer.cornerRadius = 16
            layer.cornerCurve = .continuous
            layer.borderWidth = bordeWidth ?? 0
            layer.borderColor = borderColorActive?.cgColor
            
            addPath()
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.cornerCurve = layer.cornerCurve
            
            let layers = [gradientLayer, firstShadowLayer, secondShadowLayer]
            layers.forEach {
                if self.layer.sublayers?.contains($0) == false {
                    self.layer.insertSublayer($0, at: 0)
                }
            }
            
        case .inactive:
            isUserInteractionEnabled = false
            
            backgroundColor = R.color.basicButton.inactiveColor()
            layer.borderColor = UIColor.white.cgColor
            setImage(buttonImage?.withTintColor(.white), for: .normal)
            
            layer.sublayers?.filter {
                ["firstShadowLayer", "secondShadowLayer", "gradientLayer"].contains($0.name)
            }.forEach { $0.removeFromSuperlayer() }
        }
    }
}
