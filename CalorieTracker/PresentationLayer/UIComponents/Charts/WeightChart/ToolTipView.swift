//
//  ToolTipView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.08.2022.
//

import UIKit

final class ToolTipView: UIView {
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 12)
        label.textColor = .white
        label.layer.opacity = 0.8
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 15)
        label.textColor = .white
        return label
    }()
    
    private let triangleSize = CGSize(width: 10, height: 12)
    
    private var isFirstDraw = true
    private var shape: CAShapeLayer?
    private var path: UIBezierPath?
    
    var text: (date: String, weight: String)? {
        didSet {
            dateLabel.text = text?.date
            weightLabel.text = text?.weight
        }
    }
    
    var rotated: Bool = false {
        didSet {
            if oldValue != rotated {
                switch rotated {
                case true:
                    pathRotated(path: path, angle: CGFloat.pi)
                case false:
                    pathRotated(path: path, angle: -CGFloat.pi)
                }
                shape?.path = path?.cgPath
                
                stack.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(rotated ? 18 : 6)
                    make.bottom.equalToSuperview().inset(rotated ? 6 : 18)
                }
            }
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
        guard isFirstDraw else { return }
        shape = getShape(size: bounds.size)
        layer.addSublayer(shape ?? CAShapeLayer())
        isFirstDraw = false
    }
    
    private func setupView() {
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(weightLabel)
        
        addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(3)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(18)
        }
    }
    
    private func getShape(size: CGSize) -> CAShapeLayer {
        let shape = CAShapeLayer()
        path = getPath(size: frame.size)
        shape.path = path?.cgPath
        shape.fillColor = R.color.weightWidget.weightTextColor()?.cgColor
        shape.lineWidth = 1
        shape.strokeColor = UIColor.white.cgColor
        shape.zPosition = -1
        shape.shadowRadius = 10
        shape.shadowOffset = CGSize(width: 0, height: 4)
        shape.shadowOpacity = 0.2
        shape.shadowColor = UIColor.gray.cgColor
        return shape
    }
    
    // swiftlint:disable:next function_body_length
    private func getPath(size: CGSize) -> UIBezierPath {
        let radius = min(
            layer.cornerRadius,
            size.height / 2.0 - triangleSize.height / 2.0
        )
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: radius + triangleSize.height))
        path.addArc(
            withCenter: CGPoint(
                x: radius,
                y: radius + triangleSize.height
            ),
            radius: radius,
            startAngle: CGFloat.pi,
            endAngle: -CGFloat.pi / 2.0,
            clockwise: true
        )
        addLineWithTriangle(
            path: path,
            startX: radius,
            endX: size.width - radius,
            startY: triangleSize.height,
            endY: 0
        )
        path.addArc(
            withCenter: CGPoint(
                x: size.width - radius,
                y: radius + triangleSize.height
            ),
            radius: radius,
            startAngle: -CGFloat.pi / 2.0,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(
            x: size.width,
            y: size.height - radius
        ))
        path.addArc(
            withCenter: CGPoint(
                x: size.width - radius,
                y: size.height - radius
            ),
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat.pi / 2.0,
            clockwise: true
        )
        path.addLine(to: CGPoint(
            x: radius,
            y: size.height
        ))
        path.addArc(
            withCenter: CGPoint(
                x: radius,
                y: size.height - radius
            ),
            radius: radius,
            startAngle: CGFloat.pi / 2.0,
            endAngle: CGFloat.pi,
            clockwise: true
        )
        
        pathRotated(path: path, angle: rotated ? 0 : CGFloat.pi)
        path.close()

        return path
    }
    
    private func addLineWithTriangle(path: UIBezierPath,
                                     startX: CGFloat,
                                     endX: CGFloat,
                                     startY: CGFloat,
                                     endY: CGFloat) {
        let middle = (startX + endX) / 2.0
        path.addLine(to: CGPoint(
            x: middle - triangleSize.width / 2.0,
            y: startY
        ))
        path.addLine(to: CGPoint(
            x: (startX + endX) / 2.0,
            y: endY
        ))
        path.addLine(to: CGPoint(
            x: middle + triangleSize.width / 2.0,
            y: startY
        ))
        path.addLine(to: CGPoint(
            x: endX,
            y: startY
        ))
    }
    
    private func pathRotated(path: UIBezierPath?, angle: CGFloat) {
        let size = path?.bounds.size ?? CGSize.zero
        path?.apply(CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0).inverted())
        path?.apply(CGAffineTransform(rotationAngle: angle))
        path?.apply(CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0))
    }
}
