//
//  ViewWithShadow.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.11.2022.
//

import UIKit

class ViewWithShadow: UIView {
    
    let shadows: [Shadow]
    let shadowLayer: CALayer = .init()
    
    private var firstDraw = true
    
    init(_ shadows: [Shadow]) {
        self.shadows = shadows
        super.init(frame: .zero)
        layer.addSublayer(shadowLayer)
        shadowLayer.zPosition = -1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.frame = bounds
        shadowLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        shadows.forEach { shadow in
            shadowLayer.addShadow(
                shadow: shadow,
                rect: bounds,
                cornerRadius: layer.cornerRadius,
                corner: layer.maskedCorners.rectCorners
            )
        }
    }
}

class ControlWithShadow: UIControl {
    
    let shadows: [Shadow]
    let shadowLayer: CALayer = .init()
    
    private var firstDraw = true
    
    init(_ shadows: [Shadow]) {
        self.shadows = shadows
        super.init(frame: .zero)
        layer.addSublayer(shadowLayer)
        shadowLayer.zPosition = -1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateShadows()
    }

    private func updateShadows() {
        shadowLayer.frame = bounds
        shadowLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        shadows.forEach { shadow in
            shadowLayer.addShadow(
                shadow: shadow,
                rect: bounds,
                cornerRadius: layer.cornerRadius,
                corner: layer.maskedCorners.rectCorners
            )
        }
    }
}
