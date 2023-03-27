//
//  AppMessageWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.07.2022.
//

import AsyncDisplayKit

final class AppMessageWidgetNode: CTWidgetNode {
    
    private let triangleSize = CGSize(width: 10, height: 14)
    
    private var isFirstDraw = true
    
    private lazy var textNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 2
        return node
    }()
    
    var text: String? {
        get { textNode.attributedText?.string }
        set {
            let string = newValue ?? ""
            textNode.attributedText = string.attributedSring([
                .init(
                    worldIndex: Array(0...string.split(separator: " ").count),
                    attributes: [
                        .color(R.color.messageWidget.text()),
                        .font(R.font.sfProRoundedMedium(size: UIDevice.isSmallDevice ? 15 : 18.fontScale()))
                    ]
                )
            ])
        }
    }
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 10,
                left: self.triangleSize.width + 12,
                bottom: 10,
                right: 12
            ),
            child: textNode
        )
    }
    
    override func willEnterHierarchy() {
        guard isFirstDraw else { return }
        layer.addSublayer(getShape(size: frame.size))
        isFirstDraw = false
    }
    
    private func getShape(size: CGSize) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = getPath(size: frame.size).cgPath
        shape.fillColor = R.color.messageWidget.background()?.cgColor
        shape.lineWidth = 1
        shape.strokeColor = UIColor.white.cgColor
        shape.zPosition = -1
        return shape
    }
    
    // swiftlint:disable:next function_body_length
    private func getPath(size: CGSize) -> UIBezierPath {
        let radius = min(
            layer.cornerRadius,
            size.height / 2.0 - triangleSize.height / 2.0
        )
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: triangleSize.width, y: radius))
        path.addArc(
            withCenter: CGPoint(
                x: triangleSize.width + radius,
                y: radius
            ),
            radius: radius,
            startAngle: CGFloat.pi,
            endAngle: -CGFloat.pi / 2.0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: size.width - radius, y: 0))
        path.addArc(
            withCenter: CGPoint(
                x: size.width - radius,
                y: radius
            ),
            radius: radius,
            startAngle: -CGFloat.pi / 2.0,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: size.width, y: size.height - radius))
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
        path.addLine(to: CGPoint(x: triangleSize.width + radius, y: size.height))
        path.addArc(
            withCenter: CGPoint(
                x: triangleSize.width + radius,
                y: size.height - radius
            ),
            radius: radius,
            startAngle: CGFloat.pi / 2.0,
            endAngle: CGFloat.pi,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: triangleSize.width, y: size.height / 2.0 + triangleSize.height / 2.0))
        path.addLine(to: CGPoint(x: 0, y: size.height / 2.0))
        path.addLine(to: CGPoint(x: triangleSize.width, y: size.height / 2.0 - triangleSize.height / 2.0))
        path.close()
        
        return path
    }
}
