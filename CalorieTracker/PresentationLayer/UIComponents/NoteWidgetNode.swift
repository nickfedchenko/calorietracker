//
//  NoteWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 28.07.2022.
//

import AsyncDisplayKit

final class NoteWidgetNode: CTWidgetNode {
    private lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = UIView.ContentMode.scaleAspectFit
        node.image = R.image.noteWidgetNode.notePlug()
        return node
    }()
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        setupNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: imageNode)
    }
    
    private func setupNode() {
        backgroundColor = R.color.noteWidgetNode.background()
    }
}
