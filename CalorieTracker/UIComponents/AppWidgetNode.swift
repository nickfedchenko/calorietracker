//
//  AppWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.07.2022.
//

import AsyncDisplayKit

final class AppWidgetNode: ASDisplayNode {
    private lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = R.image.appWidget.circles()
        node.contentMode = UIView.ContentMode.scaleAspectFill
        return node
    }()
    
    override init() {
        super.init()
        setupView()
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
            child: imageNode
        )
    }
    
    private func setupView() {
        automaticallyManagesSubnodes = true
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
    }
}
