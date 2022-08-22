//
//  AppWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.07.2022.
//

import AsyncDisplayKit

final class AppWidgetNode: CTWidgetButtonNode {
    private lazy var iconNode: ASImageNode = {
        let node = ASImageNode()
        node.image = R.image.appWidget.circles()
        node.contentMode = UIView.ContentMode.scaleAspectFit
        return node
    }()
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spasing = constrainedSize.min.height / 4.26
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: spasing,
                left: spasing,
                bottom: spasing,
                right: spasing
            ),
            child: iconNode
        )
    }
    
    private func setupView() {
        automaticallyManagesSubnodes = true
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
    }
}
