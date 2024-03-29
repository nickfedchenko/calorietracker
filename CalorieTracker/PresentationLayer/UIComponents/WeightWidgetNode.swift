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
        node.attributedText = getAttributedString(
            string: "WEIGHT",
            size: 18,
            color: R.color.weightWidget.weightTextColor()
        )
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
        return node
    }()
    
    var weight: CGFloat? {
        didSet {
            guard let weight = weight else { return }
            valueLabel.attributedText = getAttributedString(
                string: String(format: "%.1f", weight),
                size: 18,
                color: R.color.weightWidget.textColor()
            )
        }
    }
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        labelBackgroundNode.addSubnode(valueLabel)
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
                left: 3,
                bottom: 12,
                right: 3
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
