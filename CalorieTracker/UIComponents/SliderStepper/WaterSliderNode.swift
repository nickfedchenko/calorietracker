//
//  WaterSliderNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.08.2022.
//

import AsyncDisplayKit

final class WaterSliderNode: ASDisplayNode {
    private lazy var slider: SliderStepperNode = {
        let node = SliderStepperNode()
        node.sliderTrackColor = R.color.waterSlider.background()
        node.innerShadowColor = R.color.waterSlider.shadow()
        node.circleColor = R.color.waterSlider.shadow()
        node.sliderBackgroundColor = R.color.waterSlider.background()?.withAlphaComponent(0.1)
        node.sliderStep = 1 / CGFloat(countParts)
        node.style.height = ASDimension(unit: .points, value: 48)
        return node
    }()
    
    private var circleLayers: [CAShapeLayer] = []
    private var textWaterNodes: [(stack: ASStackLayoutSpec, node: ASTextNode)] = []
    private var positionTextNode: Int = 0
    
    var countParts: Int = 15
    var minMl: Int = 0
    var stepMl: Int = 50
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        slider.didChangeStep = { oldStep, step in
            self.circleLayers[step].fillColor = R.color.waterSlider.shadow()?.cgColor
            self.circleLayers[oldStep].fillColor = R.color.waterSlider.circles()?.cgColor
            DispatchQueue.global(qos: .userInteractive).async {
                self.textWaterNodes[oldStep].node.isHidden = true
                self.textWaterNodes[step].node.isHidden = false
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        setupWaterTextNodes(width: constrainedSize.min.width - 48)
        
        let spec = ASAbsoluteLayoutSpec(children: textWaterNodes.map { $0.stack })
        
        return ASBackgroundLayoutSpec(
            child: ASInsetLayoutSpec(
                insets: UIEdgeInsets(
                    top: 34,
                    left: 0,
                    bottom: 0,
                    right: 0
                ),
                child: slider
            ),
            background: spec
        )
    }
    
    override func willEnterHierarchy() {
        super.willEnterHierarchy()
        drawCircleses(count: countParts)
    }

    private func setupWaterTextNodes(width: CGFloat) {
        var textNodes: [(stack: ASStackLayoutSpec, node: ASTextNode)] = []
        
        for indexNode in 0...countParts {
            let textNode = ASTextNode()
            let stack = ASStackLayoutSpec.vertical()
            textNode.attributedText = getAttributedString(
                string: indexNode == 0 ? "\(minMl) ML" : "+\(minMl + indexNode * stepMl) ML",
                color: indexNode == 0 ? R.color.waterSlider.background() : R.color.waterSlider.shadow()
            )
            textNode.isHidden = indexNode != 0
            stack.horizontalAlignment = .middle
            stack.children = [textNode]
            stack.style.preferredSize = CGSize(width: 100, height: 20)
            stack.style.layoutPosition = CGPoint(
                x: -26 + CGFloat(indexNode) * width / CGFloat(countParts),
                y: 0
            )
            textNodes.append((stack: stack, node: textNode))
        }
        
        textWaterNodes = textNodes
    }
    
    private func drawCircleses(count: Int) {
        for i in 0...count {
            let radius = slider.frame.height / 2.0
            let startX = slider.frame.minX + radius
            let width = slider.frame.width - 2 * radius
            
            let shape = getCircle(
                point: CGPoint(
                    x: startX + CGFloat(i) * width / CGFloat(count),
                    y: slider.frame.minY - 9
                ),
                radius: 2,
                color: i == 0 ? R.color.waterSlider.shadow() : R.color.waterSlider.circles()
            )
            
            circleLayers.append(shape)
            layer.addSublayer(shape)
        }
    }
    
    private func getCircle(point: CGPoint, radius: CGFloat, color: UIColor?) -> CAShapeLayer {
        let path = UIBezierPath(
            arcCenter: point,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        )
        
        let circlePath = CAShapeLayer()
        circlePath.path = path.cgPath
        circlePath.zPosition = -1
        circlePath.fillColor = color?.cgColor
        
        return circlePath
    }
    
    private func getAttributedString(string: String, color: UIColor?) -> NSMutableAttributedString {
             let attributedString = NSMutableAttributedString(string: string)
             attributedString.addAttributes(
                 [
                     .foregroundColor: color ?? .black,
                     .font: UIFont.roundedFont(ofSize: 17, weight: .bold)
                 ],
                 range: NSRange(location: 0, length: string.count)
             )

             return attributedString
         }
}

extension UIFont {
     static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
         let systemFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
         let font: UIFont

         if #available(iOS 13.0, *) {
             if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
                 font = UIFont(descriptor: descriptor, size: fontSize)
             } else {
                 font = systemFont
             }
         } else {
             font = systemFont
         }

         return font
     }
 }
