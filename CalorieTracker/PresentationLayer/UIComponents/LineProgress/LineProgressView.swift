//
//  LineProgressView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.08.2022.
//

import UIKit

final class LineProgressView: UIView {
    var colors: [UIColor?]? = [.red, .blue]
    var backgroundLineColor: UIColor? = .white
    var progress: CGFloat = 0.5 {
        didSet {
            let newProgress = CGFloat(Int(progress * 1000) % 1000) / 1000.0
            shape?.strokeEnd = newProgress
            gradientLayer.frame = CGRect(
                origin: .zero,
                size: CGSize(
                    width: bounds.width * newProgress + bounds.height / 2.0,
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
        guard isFirstDraw else { return }
        let newProgress = CGFloat(Int(progress * 1000) % 1000) / 1000.0
        shape = createShapeLine(size: frame.size, color: .black)
        shape?.strokeEnd = newProgress
        gradientLayer.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: bounds.width * newProgress + bounds.height / 2.0,
                height: bounds.height
            )
        )
        
        gradientLayer.mask = shape
        layer.addSublayer(createShapeLine(size: frame.size, color: backgroundLineColor))
        layer.addSublayer(gradientLayer)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
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

}
