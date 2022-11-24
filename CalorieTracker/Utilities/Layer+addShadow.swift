//
//  Layer+addShadow.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 30.10.2022.
//

import UIKit

extension CALayer {
    func addShadow(shadow: Shadow,
                   rect: CGRect,
                   cornerRadius: CGFloat,
                   corner: UIRectCorner = .allCorners) {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corner,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
       
        let shadowLayer = CALayer()
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.shadowOpacity = shadow.opacity
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowRadius = shadow.radius
        shadowLayer.frame = bounds
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
        self.insertSublayer(shadowLayer, at: 0)
    }
}
