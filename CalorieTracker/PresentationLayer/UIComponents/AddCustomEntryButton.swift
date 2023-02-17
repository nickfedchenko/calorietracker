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
            layer.cornerRadius = 16
            layer.borderWidth = 1
            layer.borderColor = R.color.foodViewing.basicSecondary()?.cgColor
            setImage(buttonImage, for: .normal)
            setImage(buttonImagePressed, for: .highlighted)
            
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.cornerRadius = layer.cornerRadius
            
            if let firstColor = R.color.basicButton.gradientFirstColor(),
               let secondColor = R.color.basicButton.gradientSecondColor() {
                gradient.colors = [firstColor.cgColor, secondColor.cgColor]
                gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            }
            
            layer.insertSublayer(gradient, at: 0)
            
        case .inactive:
            backgroundColor = R.color.basicButton.inactiveColor()
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 1
            setImage(buttonImage?.withTintColor(.white), for: .normal)
            layer.sublayers = layer.sublayers?.filter { theLayer in
                !theLayer.isKind(of: CAGradientLayer.classForCoder())
            }
        }
    }
}
