//
//  WaterWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.07.2022.
//

import AsyncDisplayKit
import CoreGraphics

final class WaterWidgetNode: CTWidgetNode {
    struct Model {
        let progress: CGFloat
        let waterMl: String
    }
    
    private let bottomTitleLabel: ASTextNode = {
       let node = ASTextNode()
        node.style.height = .init(unit: .points, value: 24)
        return node
    }()
    
    private lazy var topTitleLabel: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = getAttributedString(
            string: R.string.localizable.diagramChartTypeWaterTitle(),
            size: 18,
            color: R.color.waterWidget.firstGradientColor()
        )
        node.style.height = .init(unit: .points, value: 24)
        return node
    }()
    
    private lazy var iconNode: ASImageNode = {
        let node = ASImageNode()
        node.image = R.image.waterWidget.waterLogo()
        node.contentMode = UIView.ContentMode.scaleAspectFit
        return node
    }()
    
    private lazy var percentageValueLabel: ASTextNode = {
        let node = ASTextNode()
        
        node.attributedText = NSAttributedString(
            string: "5",
            attributes: [
                .font: R.font.sfProRoundedBold(size: 24) ?? .systemFont(ofSize: 24),
                .foregroundColor: UIColor.white,
            ]
        )
        return node
    }()
    
    private lazy var percentageTitleLabel: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(
            string: "%",
            attributes: [
                .font: R.font.sfProRoundedBold(size: 13) ?? .systemFont(ofSize: 13),
                .foregroundColor: UIColor.white
            ]
        )
        return node
    }()
    
    private lazy var progressNode: LineProgressNode = {
        let node = LineProgressNode()
        node.progress = 0
        node.backgroundLineColor = R.color.waterWidget.backgroundColor() ?? .white
        node.colors = [
            R.color.waterWidget.firstGradientColor() ?? .blue,
            R.color.waterWidget.secondGradientColor() ?? .blue
        ]
        return node
    }()
    
    var model: Model? {
        didSet {
            didChangeModel()
        }
    }
    
    override var widgetType: WidgetContainerViewController.WidgetType { .water(specificDate: Date()) }
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let firstStack = ASStackLayoutSpec.vertical()
        firstStack.spacing = 16
        
        firstStack.children = [
            topTitleLabel,
            bottomTitleLabel
        ]
        
        let percentageStack = ASStackLayoutSpec.vertical()
        percentageStack.spacing = -5
        percentageStack.alignItems = .center
        percentageStack.justifyContent = .end
        percentageStack.children = [
            percentageValueLabel,
            percentageTitleLabel
        ]
        
        let percentageInsets = ASInsetLayoutSpec(
            insets: .init(top: 0, left: 13, bottom: 3, right: 0),
            child: percentageStack 
        )
        
        let overlay = ASOverlayLayoutSpec(child: iconNode, overlay: percentageInsets)
        let secondStack = ASStackLayoutSpec.horizontal()
        secondStack.justifyContent = .spaceBetween
        secondStack.children = [
            ASInsetLayoutSpec(
                insets: UIEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: 0
                ),
                child: firstStack
            ),
            overlay
        ]
        
        progressNode.style.height = ASDimension(unit: .points, value: 12)
        
        let thirdStack = ASStackLayoutSpec.vertical()
        thirdStack.justifyContent = .spaceBetween
        thirdStack.children = [
            secondStack,
            progressNode
        ]
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 8,
                left: 8,
                bottom: 8,
                right: 8
            ),
            child: thirdStack)
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
    }
    
    private func didChangeModel() {
        guard let model = model else { return }

        progressNode.progress = model.progress
        
        let font = R.font.sfProRoundedBold(size: 18)
        let leftColor = R.color.waterWidget.secondGradientColor()
        let rightColor = UIColor(hex: "A7F0ED")
        
        let leftAttributes: [StringSettings] = [
            .color(leftColor),
            .font(font)
        ]
        
        let rightAttributes: [StringSettings] = [
            .color(rightColor),
            .font(font)
        ]
        
        let percentageString = model.progress > 0 && model.progress != .infinity
        ? String(format: "%.0f", model.progress * 100)
        : "0"
        percentageValueLabel.attributedText = NSAttributedString(
            string: percentageString,
            attributes: [
                .font: R.font.sfProRoundedBold(size: 24) ?? .systemFont(ofSize: 24),
                .foregroundColor: UIColor.white
            ]
        )
        print(model.waterMl)
        bottomTitleLabel.attributedText = model.waterMl.attributedSring([
            .init(worldIndex: [0], attributes: leftAttributes),
            .init(worldIndex: [1, 2, 3, 4], attributes: rightAttributes)
        ])
    }
    
    private func getAttributedString(string: String, size: CGFloat, color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: R.font.sfProRoundedBold(size: size) ?? .systemFont(ofSize: size)
//                .kern: 0.38
            ],
            range: NSRange(location: 0, length: string.count)
        )
        
        return attributedString
    }
}
