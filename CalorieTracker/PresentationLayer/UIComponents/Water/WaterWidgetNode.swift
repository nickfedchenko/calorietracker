//
//  WaterWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.07.2022.
//

import AsyncDisplayKit

final class WaterWidgetNode: CTWidgetNode {
    struct Model {
        let progress: CGFloat
        let waterMl: NSAttributedString
    }
    
    private let bottomTitleLabel = ASTextNode()
    
    private lazy var topTitleLabel: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = getAttributedString(
            string: "Water",
            size: 18,
            color: R.color.waterWidget.firstGradientColor()
        )
        return node
    }()
    
    private lazy var iconNode: ASImageNode = {
        let node = ASImageNode()
        node.image = R.image.waterWidget.water()
        node.contentMode = UIView.ContentMode.scaleAspectFit
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
    
    override var widgetType: WidgetContainerViewController.WidgetType { .water }
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let firstStack = ASStackLayoutSpec.vertical()
        firstStack.children = [
            topTitleLabel,
            bottomTitleLabel
        ]
        
        let secondStack = ASStackLayoutSpec.horizontal()
        secondStack.justifyContent = .spaceBetween
        secondStack.children = [
            ASInsetLayoutSpec(
                insets: UIEdgeInsets(
                    top: 8,
                    left: 0,
                    bottom: 0,
                    right: 0
                ),
                child: firstStack
            ),
            iconNode
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

        bottomTitleLabel.attributedText = model.waterMl
        progressNode.progress = model.progress
    }
    
    private func getAttributedString(string: String, size: CGFloat, color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: UIFont.roundedFont(ofSize: size, weight: .semibold)
            ],
            range: NSRange(location: 0, length: string.count)
        )
        
        return attributedString
    }
}
