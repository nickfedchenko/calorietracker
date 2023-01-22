//
//  UIView+addSubviews.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.08.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func drawCustomStrokeWithCorners(
        topLeft: CGFloat = 0,
        topRight: CGFloat = 0,
        bottomLeft: CGFloat = 0,
        bottomRight: CGFloat = 0,
        of color: CGColor,
        with lineWidth: CGFloat
    ) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let strokePath = UIBezierPath(
            shouldRoundRect: bounds,
            topLeftRadius: topLeftRadius,
            topRightRadius: topRightRadius,
            bottomLeftRadius: bottomLeftRadius,
            bottomRightRadius: bottomRightRadius
        )
        let shape = CAShapeLayer()
        shape.path = strokePath.cgPath
        shape.lineWidth = lineWidth
        shape.strokeColor = color
        shape.fillColor = UIColor.clear.cgColor
        layer.insertSublayer(shape, at: 1)
    }
    
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(
            shouldRoundRect: bounds,
            topLeftRadius: topLeftRadius,
            topRightRadius: topRightRadius,
            bottomLeftRadius: bottomLeftRadius,
            bottomRightRadius: bottomRightRadius
        )
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}


