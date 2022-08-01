//
//  ShadowNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.07.2022.
//

import AsyncDisplayKit

final class ShadowNode: ASDisplayNode {
    
    struct Shadow {
        let color: UIColor
        let opaсity: Float
        let offset: CGSize
        let radius: CGFloat
        let shape: ShadowShape
    }
    
    enum ShadowShape {
        case circle
        case rectangle(radius: CGFloat)
    }
    
    private var flag = true

    var shadows: [Shadow]?
    
    override init() {
        super.init()
        backgroundColor = .clear
        layer.masksToBounds = false
        clipsToBounds = false
        automaticallyManagesSubnodes = true
    }
    
    override func layoutDidFinish() {
        guard let shadows = shadows, flag else { return }
        shadows.forEach { shadow in
            addShadowLayer(shadow: shadow)
        }
        flag = false
    }
    
    private func addShadowLayer(shadow: Shadow) {
        var path: UIBezierPath
        switch shadow.shape {
        case .circle:
            path = UIBezierPath(ovalIn: bounds)
        case .rectangle(let radius):
            path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        }

        let shadowLayer = CALayer()
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.shadowOpacity = shadow.opaсity
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowRadius = shadow.radius
        shadowLayer.bounds = bounds
        shadowLayer.position = CGPoint(
            x: bounds.origin.x + bounds.width / 2.0,
            y: bounds.origin.y + bounds.height / 2.0
        )
        
        path.append(UIBezierPath(rect: CGRect(
            origin: CGPoint(
                x: bounds.origin.x - (shadow.radius + 10) / 2.0,
                y: bounds.origin.y - (shadow.radius + 10) / 2.0
            ),
            size: CGSize(
                width: bounds.width + shadow.radius + 20,
                height: bounds.height + shadow.radius + 20
            )
        )))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillRule = .evenOdd
        shadowLayer.mask = mask
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
}
