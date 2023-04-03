//
//  StepsWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.07.2022.
//

import AsyncDisplayKit

final class StepsWidgetNode: CTWidgetNode {
    
    private lazy var topTextNode: ASTextNode = {
        let node = ASTextNode()
        let string = Text.steps
        let font = R.font.sfProRoundedBold(size: 5 / Double(string.count) * 18)
        let color = R.color.stepsWidget.secondGradientColor()
        let image = R.image.stepsWidget.foot()
        
        node.attributedText = string.attributedSring(
            [.init(
                worldIndex: [0],
                attributes: [.color(color), .font(font)]
            )],
            image: .init(
                image: image,
                font: font,
                position: .left
            )
        )
        return node
    }()
    
    private lazy var bottomTextNode: ASTextNode = {
        let node = ASTextNode()
        node.style.alignSelf = .center
        return node
    }()
    
    private lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = R.image.stepsWidget.flaG()
        node.contentMode = UIView.ContentMode.center
        return node
    }()
    
    private var layers: [(shape: CAShapeLayer, gradient: CAGradientLayer)] = []
    
    var steps: Int = 0 {
        didSet {
            didChangeSteps()
        }
    }
    var progress: CGFloat = 0.5 {
        didSet {
            didChangeProgress()
        }
    }
    
    override var widgetType: WidgetContainerViewController.WidgetType { .steps }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.justifyContent = .spaceBetween
        stack.children = [
            topTextNode,
            bottomTextNode
        ]
        
        let mainSpec = ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 22,
                left: 9,
                bottom: 22,
                right: 9
            ),
            child: stack
        )
        
        imageNode.style.layoutPosition = CGPoint(
            x: constrainedSize.min.width - 12 - imageNode.image!.size.width,
            y: constrainedSize.min.height - 12 - imageNode.image!.size.height
        )
        let flagSpec = ASAbsoluteLayoutSpec(children: [imageNode])
        
        return ASWrapperLayoutSpec(layoutElements: [mainSpec, flagSpec])
    }
    
    override func willEnterHierarchy() {
        super.willEnterHierarchy()
        drawBackgroundCurve(rect: bounds)
        layer.addSublayer(getCircle(point: CGPoint(x: 14, y: 14)))
        drawProgressCurve(rect: bounds, progress: progress)
    }
    
    private func didChangeSteps() {
        bottomTextNode.attributedText = String(steps).attributedSring([
            .init(
                worldIndex: [0],
                attributes: [
                    .color(R.color.stepsWidget.secondGradientColor()),
                    .font(R.font.sfProRoundedBold(size: 18))
                ]
            )
        ])
    }
    
    private func didChangeProgress() {
        if progress <= 1 {
            imageNode.image = progress < 1
            ? R.image.stepsWidget.flaG()
            : R.image.stepsWidget.performedFlag()
            
            guard let progressLayer = layers.first else { return }
            progressLayer.gradient.endPoint = CGPoint(
                x: progress <= 0.4 ? progress + 0.2 : 0.2,
                y: progress <= 0.4 ? 0 : progress
            )
            progressLayer.shape.strokeEnd = progress
        } else {
            if layers.count == 2 {
                guard let progressLayer = layers.last else { return }
                let progress = progress.truncatingRemainder(dividingBy: 1)
                progressLayer.gradient.endPoint = CGPoint(
                    x: progress <= 0.4 ? progress + 0.2 : 0.2,
                    y: progress <= 0.4 ? 0 : progress
                )
                progressLayer.shape.strokeEnd = progress
            } else {
                imageNode.image = R.image.stepsWidget.overfulfilledFlag()
                
                guard let progressLayerFirst = layers.first else { return }
                let progressLayerLast = getProgressLayers(
                    rect: bounds,
                    progress: progress.truncatingRemainder(dividingBy: 1)
                )
                layers.append(progressLayerLast)
                layer.addSublayer(progressLayerLast.gradient)

                progressLayerFirst.gradient.endPoint = CGPoint(
                    x: 0.2,
                    y: 1
                )
                progressLayerFirst.shape.strokeEnd = 1
            }
        }
    }
    
    private func drawProgressCurve(rect: CGRect, progress: CGFloat) {
        if progress <= 1 {
            layers.append(getProgressLayers(rect: rect, progress: progress))
        } else {
            layers.append(getProgressLayers(rect: rect, progress: 1))
            layers.append(getProgressLayers(rect: rect, progress: progress.truncatingRemainder(dividingBy: 1)))
        }

        layers.forEach { layer.addSublayer($0.gradient) }
    }
    
    private func drawBackgroundCurve(rect: CGRect) {
        let shape = getProgressLayers(rect: rect, progress: 1).shape
        shape.strokeColor = R.color.stepsWidget.backgroundLine()?.cgColor
        shape.zPosition = -1
        
        layer.addSublayer(shape)
    }
    
    private func getProgressLayers(rect: CGRect,
                                   progress: CGFloat) -> (shape: CAShapeLayer, gradient: CAGradientLayer) {
        let spacing: CGFloat = 14
        let rectShape = CGRect(
            x: spacing,
            y: spacing,
            width: rect.width - 2 * spacing,
            height: rect.height - 2 * spacing
        )
        
        let progressLayers = (shape: getShape(rect: rectShape), gradient: getGradientLayer(progress: progress))
        
        progressLayers.shape.strokeEnd = progress
        progressLayers.gradient.frame = rect
        progressLayers.gradient.mask = progressLayers.shape
        progressLayers.gradient.zPosition = -1
        
        return progressLayers
    }
    
    private func getGradientLayer(progress: CGFloat) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = UIColor.gradient.compactMap { $0?.cgColor }
        layer.startPoint = CGPoint(x: 0.1, y: 0)
        layer.endPoint = CGPoint(
            x: progress <= 0.4 ? progress + 0.2 : 0.2,
            y: progress <= 0.4 ? 0 : progress
        )
        return layer
    }
    
    private func getCircle(point: CGPoint) -> CAShapeLayer {
        let path = UIBezierPath(
            arcCenter: point,
            radius: 6,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        
        let circlePath = CAShapeLayer()
        circlePath.path = path.cgPath
        circlePath.zPosition = -1
        circlePath.fillColor = R.color.stepsWidget.ringColor()?.cgColor
        
        return circlePath
    }
    
    private func getShape(rect: CGRect) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = getPath(rect: rect).cgPath
        shape.lineWidth = 12
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineCap = .round
        return shape
    }
    
    private func getPath(rect: CGRect) -> UIBezierPath {
        let radius: CGFloat = rect.height / 4.0
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        path.addLine(to: CGPoint(
            x: rect.origin.x + rect.width - radius,
            y: rect.origin.y
        ))
        path.addArc(
            withCenter: CGPoint(
                x: rect.origin.x + rect.width - radius,
                y: rect.origin.y + radius
            ),
            radius: radius,
            startAngle: -CGFloat.pi / 2.0,
            endAngle: CGFloat.pi / 2.0,
            clockwise: true
        )
        path.addLine(to: CGPoint(
            x: rect.origin.x + radius,
            y: rect.origin.y + 2 * radius
        ))
        path.addArc(
            withCenter: CGPoint(
                x: rect.origin.x + radius,
                y: rect.origin.y + 3 * radius
            ),
            radius: radius,
            startAngle: -CGFloat.pi / 2.0,
            endAngle: CGFloat.pi / 2.0,
            clockwise: false
        )
        path.addLine(to: CGPoint(
            x: rect.maxX,
            y: rect.maxY
        ))
        return path
    }
}

// MARK: - Const

private extension UIColor {
    static let gradient = [
        R.color.stepsWidget.firstGradientColor(),
        R.color.stepsWidget.secondGradientColor()
    ]
}

extension StepsWidgetNode {
    struct Text {
        static let steps = " \(R.string.localizable.diagramChartTypeStepsTitle())"
    }
}
