//
//  LogoView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 15.03.2023.
//

import UIKit

final class AnimatableBorderLogoImageView: UIView {
    let gradientLayer = CAGradientLayer()
    let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.paywall.logoWithoutBorder()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawGradient()
    }
    
    private func setupSubviews() {
        addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(1)
        }
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func drawGradient() {
        gradientLayer.frame = bounds
        let maskPath = UIBezierPath(roundedRect: bounds, cornerRadius: 14).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath
        maskLayer.fillColor = UIColor.white.cgColor
        gradientLayer.colors = [
            UIColor(hex: "9CC638").cgColor,
            UIColor(hex: "E8481F").cgColor,
            UIColor(hex: "FFD529").cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.mask = maskLayer
        gradientLayer.cornerCurve = .continuous
    }
    
    func startAnimating() {
        let startAnimator = CAKeyframeAnimation(keyPath: "startPoint")
        startAnimator.duration = 3
        startAnimator.keyTimes = [0.2, 0.4, 0.6, 0.8, 1]
        startAnimator.values = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 0, y: 0)
        ]
//        startAnimator.isCumulative = true
//        startAnimator.isAdditive = true
        let endAnimator = CAKeyframeAnimation(keyPath: "endPoint")
        endAnimator.duration = 3
        endAnimator.keyTimes = [0.2, 0.4, 0.6, 0.8, 1]
        endAnimator.values = [
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 1)
        ]
//        endAnimator.isCumulative = true
//        endAnimator.isAdditive = true
        let group = CAAnimationGroup()
        group.animations = [startAnimator, endAnimator]
        group.duration = 3
        group.timingFunction = CAMediaTimingFunction(name: .linear)

//        group.autoreverses = true
        group.repeatCount = .greatestFiniteMagnitude
        gradientLayer.add(group, forKey: nil)
    }
}
