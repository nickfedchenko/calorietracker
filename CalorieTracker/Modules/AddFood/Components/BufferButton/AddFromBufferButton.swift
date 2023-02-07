//
//  AddFromBufferButton.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 05.02.2023.
//

import UIKit

final class AddFoodFromBufferButton: UIControl {
    private var foodCount: Int = 1 {
        didSet {
            updateAppearance()
        }
    }
    
    private var gradientLayer = CAGradientLayer()
    private var colors: [
        CGColor] = [
            UIColor(hex: "0C695E"),
            UIColor(hex: "004139")
        ].map { $0.cgColor }
    private var shadowLayer = CAShapeLayer()
    private var secondShadowLayer = CAShapeLayer()
    private var maskLayer = CAShapeLayer()
    private let startPoint = CGPoint(x: 0, y: 0)
    private let endPoint = CGPoint(x: 1, y: 0)
    private let strokeLayer = CAShapeLayer()
    
    private let doneLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 18)
        label.textColor = .white
        label.text = "Done".localized
        label.textAlignment = .center
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 4
        label.layer.cornerCurve = .continuous
        label.backgroundColor = UIColor(hex: "B3EFDE")
        label.font = R.font.sfProRoundedBold(size: 18)
        label.textColor = UIColor(hex: "0C695E")
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
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
        setupSubviews()
        updateAppearance()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawLayers()
        layer.cornerCurve = .continuous
    }
    
    func updateCount(to count: Int) {
        self.foodCount = count
    }
    
    private func updateAppearance() {
        countLabel.text = String(foodCount)
    }
    
    func drawLayers() {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = [0, 1]
        maskLayer.frame = bounds
        shadowLayer.frame = bounds
        secondShadowLayer.frame = bounds
        strokeLayer.frame = bounds

        maskLayer.path = path
        maskLayer.fillColor = UIColor.white.cgColor
        gradientLayer.mask = maskLayer
        
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.path = path
        shadowLayer.shadowPath = path
        shadowLayer.shadowColor = UIColor(hex: "123E5E").cgColor
        shadowLayer.shadowOpacity = 0.25
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        shadowLayer.shadowRadius = 2
        
        secondShadowLayer.fillColor = UIColor.clear.cgColor
        secondShadowLayer.shadowPath = path
//        secondShadowLayer.path = path
        secondShadowLayer.shadowColor = UIColor(hex: "06BBBB").cgColor
        secondShadowLayer.shadowOpacity = 0.2
        secondShadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        secondShadowLayer.shadowRadius = 10
        
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.path = path
        strokeLayer.lineWidth = 3
        strokeLayer.strokeColor = UIColor(hex: "B3EFDE").cgColor
    }
    
    private func setupSubviews() {
        layer.insertSublayer(gradientLayer, at: 0)
        layer.insertSublayer(maskLayer, at: 0)
        layer.insertSublayer(shadowLayer, at: 0)
        layer.insertSublayer(secondShadowLayer, at: 0)
        layer.insertSublayer(strokeLayer, at: 0)
        addSubviews(doneLabel, countLabel)
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.greaterThanOrEqualTo(30).priority(.low)
            make.trailing.equalTo(snp.centerX).offset(-4)
        }
        
        doneLabel.snp.makeConstraints { make in
            make.leading.equalTo(snp.centerX).offset(4)
            make.centerY.equalToSuperview()
        }
        
    }
}
