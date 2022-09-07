//
//  CircleActivityView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.07.2022.
//

import AsyncDisplayKit

protocol CircleActivityNodeDataSource: AnyObject {
    func circleActivityNode(_ node: CircleActivityNode, strokeColor index: Int) -> UIColor
    func circleActivityNode(_ node: CircleActivityNode, percentageOfFilling index: Int) -> CGFloat
    func circleActivityNode(_ node: CircleActivityNode, activityCircleTitleString index: Int) -> String?
    func circleActivityNode(_ node: CircleActivityNode, activityCircleTitleImage index: Int) -> UIImage?
    func circleActivityNode(_ node: CircleActivityNode, activityCircleTitleColor index: Int) -> UIColor?
    func numberOfActivityCircles(_ node: CircleActivityNode) -> Int
}

extension CircleActivityNodeDataSource {
    func circleActivityNode(_ node: CircleActivityNode, activityCircleTitleString index: Int) -> String? { return nil }
    func circleActivityNode(_ node: CircleActivityNode, activityCircleTitleImage index: Int) -> UIImage? { return nil }
    func circleActivityNode(_ node: CircleActivityNode, activityCircleTitleColor index: Int) -> UIColor? { return nil }
}

final class CircleActivityNode: ASDisplayNode {

    weak var dataSource: CircleActivityNodeDataSource?
    
    var startRadius: CGFloat = 19
    var radiusStep: CGFloat = 14
    var lineWidth: CGFloat = 12
    var colorBackCircles: UIColor? = .gray
    
    private var numberOfActivityCircles: Int?
    private var imagesAndTitles: [(image: ASImageNode, title: ASTextNode)] = []
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var children: [ASLayoutElement] = []
        numberOfActivityCircles = dataSource?.numberOfActivityCircles(self)
        setFrameForImageAndTitleNodes(rect: CGRect(origin: .zero, size: constrainedSize.min))
        
        imagesAndTitles.forEach {
            children.append($0.image)
            let stack = ASStackLayoutSpec.horizontal()
            stack.horizontalAlignment = .middle
            stack.style.layoutPosition = $0.title.style.layoutPosition
            stack.style.preferredSize = CGSize(width: lineWidth, height: lineWidth)
            stack.children = [$0.title]
            children.append(stack)
        }
        
        return ASAbsoluteLayoutSpec(sizing: .sizeToFit, children: children)
    }
    
    override func willEnterHierarchy() {
        super.willEnterHierarchy()
        reloadData()
    }
    
    func reloadData() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        numberOfActivityCircles = dataSource?.numberOfActivityCircles(self)
        imagesAndTitles = getImageAndTitleNodes()
        
        drawBackgroundRings()
        drawActivityRings()
        drawActivityRingTitles()
        
        transitionLayout(withAnimation: true, shouldMeasureAsync: false)
    }
    
    private func getImageAndTitleNodes() -> [(image: ASImageNode, title: ASTextNode)] {
        guard let numberOfActivityCircles = numberOfActivityCircles else { return [] }
        var elements: [(image: ASImageNode, title: ASTextNode)] = []
        
        for _ in 0..<numberOfActivityCircles {
            
            let imageNode: ASImageNode = {
                let node = ASImageNode()
                node.contentMode = .center
                return node
            }()
            
            let label: ASTextNode = {
                let node = ASTextNode()
                return node
            }()
            
            elements.append((image: imageNode, title: label))
        }
        
        return elements
    }
    
    private func setFrameForImageAndTitleNodes(rect: CGRect) {
        let size = CGSize(width: lineWidth, height: lineWidth)
        
        for indexShape in 0..<imagesAndTitles.count {
            let origin = CGPoint(
                x: rect.width / 2.0,
                y: rect.height / 2.0 - startRadius - radiusStep * CGFloat(indexShape)
            )
            let rectEl = CGRect(
                origin: CGPoint(
                    x: origin.x - size.width / 2.0,
                    y: origin.y - size.height / 2.0
                ),
                size: size
            )
            imagesAndTitles[indexShape].image.style.preferredSize = rectEl.size
            imagesAndTitles[indexShape].image.style.layoutPosition = rectEl.origin
            imagesAndTitles[indexShape].title.style.layoutPosition = rectEl.origin
        }
    }
    
    private func drawActivityRingTitles() {
        guard let numberOfActivityCircles = numberOfActivityCircles else { return }
        
        for indexShape in 0..<numberOfActivityCircles {
            let origin = CGPoint(
                x: frame.width / 2.0,
                y: frame.height / 2.0 - startRadius - radiusStep * CGFloat(indexShape)
            )
            
            layer.addSublayer(createCircleShape(
                center: origin,
                radius: lineWidth / 2.0,
                fillColor: dataSource?.circleActivityNode(self, strokeColor: indexShape) ?? .white
            ))
            
            if let titleImage = dataSource?.circleActivityNode(self, activityCircleTitleImage: indexShape) {
                imagesAndTitles[indexShape].image.image = titleImage
            } else if let titleStr = dataSource?.circleActivityNode(self, activityCircleTitleString: indexShape) {
                imagesAndTitles[indexShape].title.attributedText = getAttributedString(
                    string: titleStr,
                    color: dataSource?.circleActivityNode(self, activityCircleTitleColor: indexShape)
                )
            }
        }
    }
    
    private func drawActivityRings() {
        guard let numberOfActivityCircles = numberOfActivityCircles else { return }
        
        for indexShape in 0..<numberOfActivityCircles {
            layer.addSublayer(createRingShape(
                center: CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0),
                radius: startRadius + radiusStep * CGFloat(indexShape),
                start: 0,
                end: dataSource?.circleActivityNode(self, percentageOfFilling: indexShape) ?? 0,
                color: dataSource?.circleActivityNode(self, strokeColor: indexShape) ?? .white,
                lineWidth: lineWidth
            ))
        }
    }
    
    private func drawBackgroundRings() {
        guard let numberOfActivityCircles = numberOfActivityCircles else { return }
        
        for indexShape in 0..<numberOfActivityCircles {
            layer.addSublayer(createRingShape(
                center: CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0),
                radius: startRadius + radiusStep * CGFloat(indexShape),
                start: 0,
                end: 1,
                color: colorBackCircles,
                lineWidth: lineWidth
            ))
        }
    }
    
    // swiftlint:disable:next function_parameter_count
    private func createRingShape(
        center: CGPoint,
        radius: CGFloat,
        start: CGFloat,
        end: CGFloat,
        color: UIColor?,
        lineWidth: CGFloat
    ) -> CAShapeLayer {
        
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2.0 + start * 2 * CGFloat.pi,
            endAngle: -CGFloat.pi / 2.0 + end * 2 * CGFloat.pi,
            clockwise: true
        )
        
        let shapeLayer: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.path = circlePath.cgPath
            shape.fillColor = UIColor.clear.cgColor
            shape.strokeColor = color?.cgColor
            shape.lineWidth = lineWidth
            shape.lineCap = .round
            shape.zPosition = -1
            return shape
        }()
        
        return shapeLayer
    }
    
    private func createCircleShape(center: CGPoint,
                                   radius: CGFloat,
                                   fillColor: UIColor) -> CAShapeLayer {
        
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        let shapeLayer: CAShapeLayer = {
            let shape = CAShapeLayer()
            shape.path = circlePath.cgPath
            shape.fillColor = fillColor.cgColor
            shape.zPosition = -1
            return shape
        }()
        
        return shapeLayer
    }
    
    private func getAttributedString(string: String, color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: UIFont.roundedFont(ofSize: 10, weight: .bold),
                .paragraphStyle: NSTextAlignment.center
            ],
            range: NSRange(location: 0, length: string.count)
        )
        
        return attributedString
    }
}
