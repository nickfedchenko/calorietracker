//
//  SliderStepperView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.08.2022.
//

import UIKit

final class SliderStepperView: UIControl {
    private let shapeContainer = UIView()
    
    private var circleShape = CAShapeLayer()
    private var innerShadowLayer = CALayer()
    private var lineShape = SliderTrackLayer()
    private(set) var positionCircle: CGPoint?
    
    var didChangeStep: ((Int, Int) -> Void)?
    var sliderStep: CGFloat = 1 / 15
    var sliderTrackColor: UIColor? = .blue
    var innerShadowColor: UIColor? = .black
    var circleColor: UIColor? = .blue
    
    var sliderBackgroundColor: UIColor? {
        didSet {
            backgroundColor = sliderBackgroundColor
        }
    }
    var step: Int = 0 {
        didSet {
            if step != oldValue {
                didChangeStep?(oldValue, step)
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
        lineShape.cornerRadius = frame.height / 2.0
        setupCircleShape()
        lineShapeInnerShadow()
        supernodeInnerShadow()
    }
    
    private func setupView() {
        isUserInteractionEnabled = true
        clipsToBounds = true
        shapeContainer.layer.addSublayer(circleShape)
        shapeContainer.isUserInteractionEnabled = false
        lineShape.slider = self
        lineShape.contentsScale = UIScreen.main.scale
        lineShape.isHidden = true
        layer.masksToBounds = true
        layer.cornerCurve = .circular
        layer.addSublayer(lineShape)
        updateLayerFrames()
        
        addSubview(shapeContainer)
        
        shapeContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
    }
    
    private func setupCircleShape() {
        let path = UIBezierPath(
            ovalIn: CGRect(
                origin: .zero,
                size: CGSize(
                    width: shapeContainer.bounds.height,
                    height: shapeContainer.bounds.height
                )
            )
        )
        
        circleShape.path = path.cgPath
        circleShape.fillColor = circleColor?.cgColor
        circleShape.lineWidth = 2
        circleShape.strokeColor = UIColor.white.cgColor
    }
    
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        lineShape.frame = bounds
        lineShape.setNeedsDisplay()
        circleShape.frame = CGRect(
            origin: positionCircle ?? .zero,
            size: circleShape.frame.size
        )
        
        let shadowRect = CGRect(
            origin: .zero,
            size: CGSize(
                width: positionCircle?.x ?? 0 + frame.height,
                height: frame.height
            )
        )
        innerShadowLayer.shadowPath = getShadowPath(rect: shadowRect).cgPath
        CATransaction.commit()
    }
    
    private func lineShapeInnerShadow() {
        innerShadowLayer.frame = lineShape.bounds
        
        innerShadowLayer.shadowPath = getShadowPath(rect: lineShape.bounds).cgPath
        innerShadowLayer.masksToBounds = true
        innerShadowLayer.shadowColor = innerShadowColor?.cgColor
        innerShadowLayer.shadowOffset = CGSize.zero
        innerShadowLayer.shadowOpacity = 1
        innerShadowLayer.shadowRadius = 16
        lineShape.addSublayer(innerShadowLayer)
    }
    
    private func supernodeInnerShadow() {
        let innerShadowLayer = CALayer()
        innerShadowLayer.frame = bounds
        innerShadowLayer.shadowPath = getShadowPath(rect: bounds).cgPath
        innerShadowLayer.masksToBounds = true
        innerShadowLayer.shadowColor = R.color.waterSlider.backgroundShadow()?.cgColor
        innerShadowLayer.shadowOffset = CGSize.zero
        innerShadowLayer.shadowOpacity = 1
        innerShadowLayer.shadowRadius = 16
        layer.addSublayer(innerShadowLayer)
    }
    
    private func getShadowPath(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(
            roundedRect: rect.insetBy(dx: -20, dy: -20),
            cornerRadius: lineShape.cornerRadius
        )
        let innerPart = UIBezierPath(
            roundedRect: rect,
            cornerRadius: lineShape.cornerRadius
        ).reversing()
        path.append(innerPart)
        
        return path
    }
}

extension SliderStepperView {    
    override func beginTracking(_ touch: UITouch, with touchEvent: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let radius = shapeContainer.bounds.height / 2.0
        let position = CGPoint(
            x: min(shapeContainer.bounds.maxX - radius, max(radius, location.x)) - radius,
            y: 0
        )
        
        lineShape.isHidden = position.x == 0
        positionCircle = position
        updateLayerFrames()
        let step = sliderStep * (shapeContainer.bounds.width - 2 * radius)
        self.step = Int(round(position.x) / round(step))
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with touchEvent: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let radius = shapeContainer.bounds.height / 2.0
        let position = CGPoint(
            x: min(shapeContainer.bounds.maxX - radius, max(radius, location.x)) - radius,
            y: 0
        )
        
        lineShape.isHidden = !(position.x > 0)
        positionCircle = position
        updateLayerFrames()
        let step = sliderStep * (shapeContainer.bounds.width - 2 * radius)
        self.step = Int(round(position.x) / round(step))
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with touchEvent: UIEvent?) {
        guard let location = touch?.location(in: self) else { return }
        let radius = shapeContainer.bounds.height / 2.0
        let step = sliderStep * (shapeContainer.bounds.width - 2 * radius)
        let position = CGPoint(
            x: min(
                shapeContainer.bounds.maxX - radius,
                max(radius, round(location.x / step) * step)
            ) - radius,
            y: 0
        )
        
        lineShape.isHidden = !(position.x > 0)
        positionCircle = position
        updateLayerFrames()
        self.step = Int(round(position.x) / round(step))
    }
}
