//
//  LineProgressView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.08.2022.
//

import UIKit

final class LineProgressView: UIView {
    var colors: [UIColor?]? = [UIColor(hex: "42D7D7"), UIColor(hex: "00BCE5")]
    var backgroundLineColor: UIColor? = .white
    var progress: CGFloat = 0.5 {
        didSet {
            guard progress.isNormal else {
                progress = 0
                return
            }
            
            let newProgress = CGFloat(Int(progress * 1000) % 1000) / 1000.0
//            let animator = CABasicAnimation(keyPath: "strokeEnd")
//            animator.fromValue = shape?.strokeEnd
//            animator.toValue = newProgress
//            animator.duration = 0.4
//            shape?.add(animator, forKey: "strokeEnd")
            shape?.strokeEnd = newProgress
            
            gradientLayer.frame = CGRect(
                origin: .zero,
                size: CGSize(
                    width: bounds.width * newProgress + bounds.height,
                    height: bounds.height
                )
            )
            switch progress {
            case 0..<1:
                imageView.image = R.image.stepsWidget.flaG()
            case 1:
                imageView.image = R.image.stepsWidget.performedFlag()
            case 1...:
                imageView.image = R.image.stepsWidget.overfulfilledFlag()
            default:
                imageView.image = nil
            }
        }
    }
    var isHiddenFlag: Bool {
        get { imageView.isHidden }
        set { imageView.isHidden = newValue }
    }
    
    private var shape: CAShapeLayer?
    private var isFirstDraw = true
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = colors?.compactMap { $0?.cgColor }
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.stepsWidget.flaG()
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        guard isFirstDraw else { return }
        shape?.removeFromSuperlayer()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        imageView.removeFromSuperview()
        let newProgress = CGFloat(Int(progress * 1000) % 1000) / 1000.0
        shape = createShapeLine(size: frame.size, color: .black)
        shape?.strokeEnd = newProgress
        UIView.animate(withDuration: 0.4, delay: 0) {
            self.gradientLayer.frame = CGRect(
                origin: .zero,
                size: CGSize(
                    width: self.bounds.width * newProgress + self.bounds.height,
                    height: self.bounds.height
                )
            )
        }
        gradientLayer.colors = colors?.compactMap { $0?.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.mask = shape
        layer.addSublayer(createShapeLine(size: frame.size, color: backgroundLineColor))
        layer.addSublayer(gradientLayer)
        
        addSubview(imageView)
        imageView.snp.remakeConstraints { make in
            make.height.equalTo(29)
            make.width.equalTo(11)
            make.trailing.equalToSuperview().offset(-bounds.height / 2.0)
            make.bottom.equalToSuperview().offset(2 - bounds.height / 2.0)
        }
        
        isFirstDraw = false
    }
    
    private func createShapeLine(size: CGSize, color: UIColor?) -> CAShapeLayer {
        let linePath: UIBezierPath = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: size.height / 2.0, y: size.height / 2.0))
            path.addLine(to: CGPoint(x: size.width - size.height / 2.0, y: size.height / 2.0))
            return path
        }()

        let lineShape: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.path = linePath.cgPath
            shape.strokeColor = color?.cgColor
            shape.lineWidth = size.height
            shape.lineCap = .round
            return shape
        }()
        return lineShape
    }

//    func updateShapes() {
//        let progress = CGFloat(Int(progress * 1000) % 1000) / 1000.0
//        let strokeAnimator = CABasicAnimation(keyPath: "strokeEnd")
//        let frameAnimator = CABasicAnimation(keyPath: "frame")
//        strokeAnimator.toValue = progress
//        frameAnimator.toValue = CGRect(
//            origin: .zero,
//            size: CGSize(
//                width: bounds.width * progress + bounds.height,
//                height: bounds.height
//            )
//        )
//        strokeAnimator.duration = 0.4
//        frameAnimator.duration = 0.4
//        strokeAnimator.timingFunction = CAMediaTimingFunction(name: .easeIn)
//        frameAnimator.timingFunction = CAMediaTimingFunction(name: .easeIn)
//        shape?.add(strokeAnimator, forKey: nil)
//        gradientLayer.add(frameAnimator, forKey: nil)
//
//    }
}
