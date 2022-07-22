//
//  ShadowNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.07.2022.
//

import AsyncDisplayKit
import Foundation
import UIKit

final class ShadowNode: ASDisplayNode {
    
    struct Shadow {
        let color: UIColor
        let opacity: Float
        let offset: CGSize
        let radius: CGFloat
        let shape: ShadowShape
    }
    
    enum ShadowShape {
        case circle
        case rectangle(radius: CGFloat)
    }
    
    var shadows: [Shadow]?
    
    init(node: ASDisplayNode) {
        super.init()
        backgroundColor = .clear
        layer.masksToBounds = false
        clipsToBounds = false
        automaticallyManagesSubnodes = true
        
        addSubnode(node)
        layoutSpecBlock = { _, _ in
            return ASInsetLayoutSpec(
                insets: UIEdgeInsets.zero,
                child: ASWrapperLayoutSpec(layoutElement: node)
            )
        }
    }
    
    override func willEnterHierarchy() {
        super.willEnterHierarchy()
        guard let shadows = shadows else { return }
        shadows.forEach { shadow in
            addShadowLayer(shadow: shadow)
        }
    }
    
    private func addShadowLayer(shadow: Shadow) {
        var path: UIBezierPath
        switch shadow.shape {
        case .circle:
            path = UIBezierPath(ovalIn: bounds)
        case .rectangle(let radius):
            path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        }
        print(shadows)
        print("bounds now are \(bounds)")
        let shadowLayer = CALayer()
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.shadowOpacity = shadow.opacity
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
