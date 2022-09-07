//
//  LineProgressNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.07.2022.
//

import AsyncDisplayKit

final class LineProgressNode: ASDisplayNode {
    var colors: [UIColor]? = [.red, .blue]
    var backgroundLineColor: UIColor = .white
    var progress: CGFloat = 0.5 {
        didSet {
            UIView.animate(withDuration: 10, delay: 0, options: .curveEaseInOut) { [weak self] in
                self?.shape?.strokeEnd = self?.progress ?? 1
            } completion: { [weak self] _ in
                self?.shape?.strokeEnd = self?.progress ?? 1
            }
        }
    }
    
    private var shape: CAShapeLayer?
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = colors?.compactMap { $0.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    override func willEnterHierarchy() {
        shape = createShapeLine(size: frame.size, color: .black)
        shape?.strokeEnd = progress
        gradientLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size)
        gradientLayer.mask = shape
        layer.addSublayer(createShapeLine(size: frame.size, color: backgroundLineColor))
        layer.addSublayer(gradientLayer)
    }
    
    private func createShapeLine(size: CGSize, color: UIColor) -> CAShapeLayer {
        let linePath: UIBezierPath = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: size.height / 2.0, y: size.height / 2.0))
            path.addLine(to: CGPoint(x: size.width - size.height / 2.0, y: size.height / 2.0))
            return path
        }()

        let lineShape: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.path = linePath.cgPath
            shape.strokeColor = color.cgColor
            shape.lineWidth = size.height
            shape.lineCap = .round
            return shape
        }()
        
        return lineShape
    }
}
