//
//  StatisticsCircleView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 28.10.2022.
//

import UIKit

final class StatisticsCircleView: UIView {
    
    var backgroundCircleColor: UIColor? {
        get { UIColor(cgColor: backgroundShape.strokeColor ?? UIColor.white.cgColor) }
        set { backgroundShape.strokeColor = newValue?.cgColor }
    }
    
    var firstCircleColor: UIColor? {
        get { UIColor(cgColor: firstShape.strokeColor ?? UIColor.white.cgColor) }
        set { firstShape.strokeColor = newValue?.cgColor }
    }
    
    var secondCircleColor: UIColor? {
        get { UIColor(cgColor: secondShape.strokeColor ?? UIColor.white.cgColor) }
        set { secondShape.strokeColor = newValue?.cgColor }
    }
    
    private var parh: UIBezierPath?
    
    private lazy var backgroundShape: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.lineCap = .round
        shape.lineWidth = 6
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
    
    private lazy var firstShape: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.lineCap = .round
        shape.lineWidth = 6
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
    
    private lazy var secondShape: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.lineCap = .round
        shape.lineWidth = 6
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.contentMode = .bottom
        label.text = "Carb"
        return label
    }()
    
    private lazy var volLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.contentMode = .top
        label.text = "38 g"
        return label
    }()
    
    init(from: CGFloat, to: CGFloat) {
        super.init(frame: .zero)
        firstShape.strokeStart = 0
        firstShape.strokeEnd = from
        secondShape.strokeStart = from
        secondShape.strokeEnd = from + to
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shapes = [
            backgroundShape,
            firstShape,
            secondShape
        ]
        
        layer.cornerRadius = frame.height / 2.0
        
        parh = UIBezierPath(
            arcCenter: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0),
            radius: layer.cornerRadius,
            startAngle: .pi / -2.0,
            endAngle: .pi / 2.0 * 3,
            clockwise: true
        )
        
        shapes.forEach {
            $0.frame = bounds
            $0.path = parh?.cgPath
        }
    }
    
    private func setupView() {
        layer.cornerCurve = .circular
        backgroundColor = .white
        
        layer.addSublayer(backgroundShape)
        layer.addSublayer(firstShape)
        layer.addSublayer(secondShape)
        
        addSubviews(titleLabel, volLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        volLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.snp.centerY)
        }
    }
}
