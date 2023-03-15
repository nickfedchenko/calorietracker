//
//  CommonButton.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation
import UIKit

class CommonButton: UIButton {
    
    // MARK: - Style
    
    enum Style {
        case filled
        case bordered
        case gradientBordered
    }
    
    override var isEnabled: Bool {
        didSet {
            didChangedStyle()
        }
    }
    
    private var backgroundGradientLayer: CAGradientLayer?
    private var strokeGradientLayer: CAGradientLayer?
    private var maskLayer: CAShapeLayer?
    
    // MARK: - Private properties
    
    private let style: Style
        
    // MARK: - Initialization
    
    init(style: Style, text: String) {
        self.style = style
        
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        configureViews()
        didChangedStyle()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard style == .gradientBordered else { return }
        makeGradients()
    }
    
    private func configureViews() {
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        titleLabel?.font = R.font.sfProRoundedBold(size: 22)
    }
    
    private func didChangedStyle() {
        switch style {
        case .filled:
            backgroundColor = isEnabled ? R.color.onboardings.radialGradientFirst() : R.color.onboardings.commonButton()
            setTitleColor(.white, for: .normal)
            layer.cornerRadius = 16
            layer.cornerCurve = .continuous
            clipsToBounds = true
        case .bordered:
            backgroundColor = .clear
            setTitleColor(R.color.onboardings.borders(), for: .normal)
            layer.borderColor = UIColor(named: R.color.onboardings.borders.name)?.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 16
            layer.cornerCurve = .continuous
            clipsToBounds = true
        case .gradientBordered:
            backgroundGradientLayer = CAGradientLayer()
            strokeGradientLayer = CAGradientLayer()
            maskLayer = CAShapeLayer()
            layer.insertSublayer(backgroundGradientLayer!, at: 0)
            layer.insertSublayer(strokeGradientLayer!, at: 0)
            startAnimating()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeGradients() {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 2, dy: 2), cornerRadius: 16).cgPath
      
        let strokePath = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        backgroundGradientLayer?.frame = bounds
        backgroundGradientLayer?.type = .radial
        backgroundGradientLayer?.colors = [UIColor(hex: "12834D").cgColor, UIColor(hex: "18995B").cgColor]
        backgroundGradientLayer?.startPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundGradientLayer?.endPoint = CGPoint(x: 1, y: 1)
        backgroundGradientLayer?.locations = [0, 1]
        maskLayer?.path = path
        maskLayer?.fillColor = UIColor.white.cgColor
        maskLayer?.frame = bounds
        strokeGradientLayer?.frame = bounds
//        strokeGradientLayer?.frame = bounds.insetBy(dx: -2, dy: -2)
        strokeGradientLayer?.colors = [
            UIColor(hex: "30BB78").cgColor,
            UIColor(hex: "62D3B4").withAlphaComponent(0.2).cgColor
        ]
        strokeGradientLayer?.startPoint = CGPoint(x: 0.5, y: 0.5)
        strokeGradientLayer?.endPoint = CGPoint(x: 0, y: 1)
    
        let strokeMaskLayer = CAShapeLayer()
        strokeMaskLayer.path = strokePath
        strokeMaskLayer.fillColor = UIColor.white.cgColor
        backgroundGradientLayer?.mask = maskLayer
        strokeGradientLayer?.mask = strokeMaskLayer
    }
    
    func startAnimating() {
        let startAnimator = CAKeyframeAnimation(keyPath: "startPoint")
        startAnimator.duration = 3
        startAnimator.keyTimes = [0.1666, 0.3333, 0.5, 0.66666, 0.8333, 1]
        startAnimator.values = [
            CGPoint(x: 0.5, y: 0.5),
            CGPoint(x: 0.5, y: 0.5),
            CGPoint(x: 0.5, y: 0.5),
            CGPoint(x: 0.5, y: 0.5),
            CGPoint(x: 0.5, y: 0.5),
            CGPoint(x: 0.5, y: 0.5)
        ]
        let endAnimator = CAKeyframeAnimation(keyPath: "endPoint")
        endAnimator.duration = 3
        endAnimator.keyTimes = [0.1666, 0.3333, 0.5, 0.66666, 0.8333, 1]
        endAnimator.values = [
            CGPoint(x: 0, y: 1),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 0.5, y: 0),
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 1)
        ]
        
        let group = CAAnimationGroup()
        group.animations = [startAnimator, endAnimator]
        group.duration = 3
        group.timingFunction = CAMediaTimingFunction(name: .linear)
//        group.autoreverses = true
        group.repeatCount = .greatestFiniteMagnitude
        strokeGradientLayer?.add(group, forKey: nil)
    }
}
