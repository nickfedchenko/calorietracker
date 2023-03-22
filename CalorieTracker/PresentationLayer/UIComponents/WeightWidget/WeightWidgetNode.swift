//
//  WeightWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.07.2022.
//

import AsyncDisplayKit

final class WeightWidgetNode: CTWidgetNode {
    private lazy var titleLabel: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = R.string.localizable.widgetWeightTitle().attributedSring([
            .init(
                worldIndex: [0],
                attributes: [
                    .color(UIColor(hex: "5BAA1C")),
                    .font(R.font.sfProRoundedBold(size: 18)),
                ]
            )
        ])
        return node
    }()
    
    private lazy var valueLabel: ASTextNode = {
        let node = ASTextNode()
        return node
    }()
    
    private lazy var labelBackgroundNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = R.color.weightWidget.backgroundLabelColor()
        node.layer.cornerCurve = .continuous
        node.layer.cornerRadius = 16
        return node
    }()
    
    private lazy var iconNode: ASImageNode = {
        let node = ASImageNode()
        node.image = R.image.weightWidget.scale()
        node.contentMode = .scaleAspectFit
        return node
    }()
    
    var weight: CGFloat? {
        didSet {
            guard let weight = weight else { return }
            valueLabel.attributedText = Double(weight).clean(with: 1).attributedSring([
                .init(
                    worldIndex: [0],
                    attributes: [
                        .color(R.color.weightWidget.textColor()),
                        .font(R.font.sfProRoundedBold(size: 18))
                    ]
                )
            ])
        }
    }
    
    override var widgetType: WidgetContainerViewController.WidgetType { .weight }
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        labelBackgroundNode.addSubnode(valueLabel)
        iconNode.style.preferredSize = CGSize(width: 106, height: 20)
        labelBackgroundNode.layoutSpecBlock = { _, _ in
            return ASInsetLayoutSpec(
                insets: UIEdgeInsets(
                    top: 8,
                    left: 12,
                    bottom: 8,
                    right: 12
                ),
                child: self.valueLabel
            )
        }
        
        let stack = ASStackLayoutSpec.vertical()
        stack.justifyContent = .spaceBetween
        stack.spacing = 3
        stack.horizontalAlignment = .middle
        stack.children = [
            labelBackgroundNode,
            iconNode,
            titleLabel
        ]
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 11,
                left: 0,
                bottom: 12,
                right: 0
            ),
            child: stack
        )
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        weight = 0
    }
}
